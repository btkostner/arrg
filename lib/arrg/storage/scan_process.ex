defmodule Arrg.Storage.ScanProcess do
  @moduledoc """
  A task that scans a file system for files.
  """

  use GenServer

  import Ecto.Query

  require Logger

  alias Arrg.Repo
  alias Arrg.Storage.File
  alias Arrg.Storage.FileSystem
  alias Arrg.Storage.FileType
  alias Arrg.Storage.Implementation

  @registry Arrg.TaskRegistry
  @supervisor Arrg.TaskSupervisor

  @doc """
  Creates a new file system scan task.

  ## Examples

      iex> create(file_system)
      {:ok, pid}

      iex> create(file_system)
      {:error, {:already_started, pid}}

  """
  def create(file_system) do
    DynamicSupervisor.start_child(@supervisor, {__MODULE__, file_system})
  end

  @doc """
  Returns the pid of the currently running scan task.

  ## Examples

      iex> get(file_system)
      {:ok, pid}

      iex> get(file_system)
      nil

  """
  def get(file_system) do
    {:via, _registry_module, {@registry, key}} = via(file_system)

    case Horde.Registry.lookup(@registry, key) do
      [{pid, _}] -> {:ok, pid}
      [] -> nil
    end
  end

  @doc false
  def start_link(file_system) do
    GenServer.start_link(__MODULE__, [file_system], name: via(file_system))
  end

  defp via(%FileSystem{name: name}), do: via(name)

  defp via(name) when is_binary(name),
    do: {:via, Horde.Registry, {@registry, {__MODULE__, name}}}

  @impl GenServer
  def init([file_system]) do
    {:ok, %{file_system: file_system}, {:continue, :run}}
  end

  @impl GenServer
  def handle_continue(:run, state) do
    Logger.info("Running scan for #{state.file_system.name}")
    %{file_system: %{name: file_system_name} = file_system} = state

    with {:ok, files} <- Implementation.scan(file_system, "/") do
      Logger.info("Processing #{length(files)} files")

      now = DateTime.utc_now()

      files
      |> Flow.from_enumerable()
      |> Flow.map(fn file -> process_file(file, state.file_system, now) end)
      |> Flow.reject(&is_nil/1)
      |> Flow.stream()
      |> Enum.reduce(Ecto.Multi.new(), fn changeset, multi ->
        Ecto.Multi.insert(multi, changeset.changes.path, changeset, on_conflict: :replace_all)
      end)
      |> Ecto.Multi.delete_all(:remove_old, fn _results ->
        from(f in File, where: f.file_system_name == ^file_system_name and f.scanned_at > ^now)
      end)
      |> Repo.transaction(timeout: :infinity)
    end

    {:stop, :normal, state}
  end

  defp process_file(path, file_system, now) do
    {:ok, stream} = Implementation.read(file_system, path)

    type =
      stream
      |> Stream.take(1)
      |> Enum.at(0)
      |> FileType.identify()

    File.changeset(%File{}, %{
      file_system_name: file_system.name,
      path: path,
      mime_type: type,
      scanned_at: now
    })
  rescue
    err ->
      case err do
        %MatchError{term: {:error, :enoent}} ->
          nil

        err ->
          Logger.warn("""
          Unable to process file #{path} on #{file_system.name}:
          #{err}
          """)

          nil
      end
  end
end
