defmodule Arrg.Storage.ScanProcess do
  @moduledoc """
  A task that scans a file system for files.
  """

  use GenServer

  alias Arrg.Storage.FileSystem

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

    case Horde.Registry.lookup(@registry, key) |> IO.inspect(label: "lookup") do
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
    {:ok,
     %{
       directories: [],
       file_system: file_system,
       files: []
     }, {:continue, :run}}
  end

  @impl GenServer
  def handle_continue(:run, state) do
    IO.inspect("running scan for #{state.file_system.name}")
    Process.sleep(10_000)
    IO.inspect("scan complete")
    {:stop, :normal, state}
  end
end
