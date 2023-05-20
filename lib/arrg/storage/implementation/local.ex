defmodule Arrg.Storage.LocalImplementation do
  @moduledoc """
  A local file system storage implementation.
  """
  @behaviour Arrg.Storage.ImplementationBehaviour

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          root: String.t()
        }

  @primary_key false
  embedded_schema do
    field :root, :string
  end

  @doc """
  Returns an `Ecto.Changeset` for a local implementation configuration struct
  and given attributes.
  """
  @impl Arrg.Storage.ImplementationBehaviour
  def changeset(config, attrs) do
    config
    |> cast(attrs, [:root])
    |> validate_required([:root])
  end

  @doc """
  Returns a friendly name for the local implementation.
  """
  @impl Arrg.Storage.ImplementationBehaviour
  def friendly_name, do: "Local"

  @doc """
  Reads a given file from the local file system. Returns a stream
  of data.
  """
  @impl Arrg.Storage.ImplementationBehaviour
  def read(%{root: root}, path, _opts) do
    stream =
      root
      |> Path.join(path)
      |> File.stream!([], 2048)

    {:ok, stream}
  catch
    e -> {:error, e}
  end

  @doc """
  Writes a stream of data to the local file system.
  """
  @impl Arrg.Storage.ImplementationBehaviour
  def write(stream, %{root: root}, path, _opts) do
    full_path = Path.join(root, path)

    stream
    |> Stream.into(full_path)
    |> Stream.run()
  end

  @doc """
  Deletes a file from the local file system.
  """
  @impl Arrg.Storage.ImplementationBehaviour
  # sobelow_skip ["Traversal.FileModule"]
  def delete(%{root: root}, path, _opts) do
    root
    |> Path.join(path)
    |> File.rm()
  end
end
