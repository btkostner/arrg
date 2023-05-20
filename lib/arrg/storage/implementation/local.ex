defmodule Arrg.Storage.LocalImplementation do
  @moduledoc """
  A local file system storage implementation.
  """
  @behaviour Arrg.Storage.ImplementationBehaviour

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :root, :string
  end

  @impl Arrg.Storage.ImplementationBehaviour
  def changeset(config, attrs) do
    config
    |> cast(attrs, [:root])
    |> validate_required([:root])
  end

  @impl Arrg.Storage.ImplementationBehaviour
  def friendly_name, do: "Local"

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

  @impl Arrg.Storage.ImplementationBehaviour
  def write(stream, %{root: root}, path, _opts) do
    full_path = Path.join(root, path)

    stream
    |> Stream.into(full_path)
    |> Stream.run()
  end

  @impl Arrg.Storage.ImplementationBehaviour
  def delete(%{root: root}, path, _opts) do
    root
    |> Path.join(path)
    |> File.rm()
  end
end
