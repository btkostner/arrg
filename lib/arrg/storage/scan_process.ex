defmodule Arrg.Storage.ScanProcess do
  @moduledoc """
  A task that scans a file system for files.
  """

  use GenServer

  alias Arrg.Storage.File
  alias Arrg.Storage.FileSystem
  alias Arrg.Storage.Implementation

  require Logger

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

    with {:ok, files} <- Implementation.glob(state.file_system, "**/*") do
      Logger.info("Processing #{length(files)} files")

      files
      |> Flow.from_enumerable()
      |> Flow.map(fn file -> process_file(file, state.file_system) end)
      |> Flow.reject(&is_nil/1)
      |> Flow.run()
    end

    {:stop, :normal, state}
  end

  defp process_file(path, file_system) do
    {:ok, stream} = Implementation.read(file_system, path)

    type =
      stream
      |> Stream.take(1)
      |> Enum.at(0)
      |> process_magic_number()

    file = %File{
      file_system: file_system,
      path: path,
      mime_type: type
    }

    file |> to_string() |> Logger.debug()

    file
  rescue
    err ->
      case err do
        %MatchError{term: {:error, :enoent}} ->
          nil

        err ->
          IO.inspect(err, label: "error")
          Logger.warn("Unable to process file #{path} on #{file_system.name}", error: err)
          nil
      end
  end

  defp process_magic_number(<<0x66, 0x4C, 0x61, 0x43>> <> _), do: "audio/x-flac"

  defp process_magic_number(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>> <> _), do: "image/png"
  defp process_magic_number(<<0xFF, 0xD8, 0xFF, 0xDB>> <> _), do: "image/jpeg"

  defp process_magic_number(<<0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01>> <> _),
    do: "image/jpeg"

  defp process_magic_number(<<0xFF, 0xD8, 0xFF, 0xEE>> <> _), do: "image/jpeg"
  defp process_magic_number(<<0xFF, 0xD8, 0xFF, 0xE1, _, _, 0x45, 0x78, 0x69, 0x66, 0x00, 0x00>> <> _), do: "image/jpeg"

  defp process_magic_number(<<0xEF, 0xBB, 0xBF>> <> _), do: "text/plain"
  defp process_magic_number(bytes) when is_binary(bytes), do: "text/plain"

  defp process_magic_number(_bytes), do: nil
end
