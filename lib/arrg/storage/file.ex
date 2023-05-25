defmodule Arrg.Storage.File do
  @moduledoc """
  A table of files in various file systems.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          file_system: Arrg.Storage.FileSystem.t(),
          path: String.t(),
          mime_type: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @primary_key false
  schema "storage_files" do
    belongs_to :file_system, Arrg.Storage.FileSystem,
      foreign_key: :file_system_name,
      references: :name,
      primary_key: true

    field :path, :string, primary_key: true
    field :mime_type, :string

    timestamps()
  end

  @doc false
  def changeset(file_system, attrs) do
    file_system
    |> cast(attrs, [:file_system, :path, :mime_type])
    |> validate_required([:file_system, :path])
  end
end

defimpl String.Chars, for: Arrg.Storage.File do
  def to_string(%Arrg.Storage.File{file_system_name: file_system_name, path: path, mime_type: mime_type}) do
    "#{file_system_name}:#{path} (#{mime_type})"
  end
end
