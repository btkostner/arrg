defmodule Arrg.Storage.Scan do
  @doc """
  A record of every time we've scanned a file system for files.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          file_system: Arrg.Storage.FileSystem.t(),
          pid: pid() | nil,
          results: map(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t(),
          completed_at: DateTime.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "storage_scans" do
    belongs_to :file_system, Arrg.Storage.FileSystem,
      foreign_key: :file_system_name,
      references: :name,
      primary_key: true

    field :pid, :any, virtual: true
    field :results, :map

    timestamps()
    field :completed_at, :naive_datetime
  end

  @doc false
  def changeset(scan, attrs) do
    scan
    |> cast(attrs, [:results, :completed_at])
    |> cast_assoc(:file_system)
    |> validate_required([:file_system])
  end

  @doc """
  Possibly adds virtual fields to a struct.
  """
  def populate_fields(scans) when is_list(scans),
    do: Enum.map(scans, &populate_fields/1)

  def populate_fields(scan) do
    scan
  end
end
