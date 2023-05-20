defmodule Arrg.Storage.File do
  @moduledoc """
  A table of files in various file systems.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          file_system: Arrg.Storage.FileSystem.t(),
          path: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @primary_key false
  schema "storage_files" do
    belongs_to :file_system, Arrg.Storage.FileSystem, references: :name, primary_key: true
    field :path, :string, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(file_system, attrs) do
    file_system
    |> cast(attrs, [:file_system, :path])
    |> validate_required([:file_system, :path])
  end
end
