defmodule Arrg.Storage.FileSystem do
  @moduledoc """
  Stores different named file systems. Each one has a name,
  Arrg.Storage.Implementation module, and a config.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import PolymorphicEmbed

  @type t :: %__MODULE__{
          name: String.t(),
          type: atom(),
          implementation: struct(),
          files: [Arrg.Storage.File],
          scans: [Arrg.Storage.Scan],
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @types ~w(movies shows music)a

  @derive {Phoenix.Param, key: :name}
  @primary_key {:name, :string, autogenerate: false}
  @foreign_key_type :string
  schema "storage_file_systems" do
    field :type, Ecto.Enum, values: @types

    polymorphic_embeds_one(:implementation,
      types: [
        local: Arrg.Storage.LocalImplementation
      ],
      default: %Arrg.Storage.LocalImplementation{},
      on_type_not_found: :raise,
      on_replace: :update
    )

    has_many :files, Arrg.Storage.File, foreign_key: :file_system_name

    has_many :scans, Arrg.Storage.Scan, foreign_key: :file_system_name

    timestamps()
  end

  @doc false
  def changeset(file_system, attrs) do
    file_system
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
    |> validate_inclusion(:type, @types)
    |> cast_polymorphic_embed(:implementation, required: true)
  end
end
