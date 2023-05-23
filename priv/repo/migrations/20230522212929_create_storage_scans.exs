defmodule Arrg.Repo.Migrations.CreateStorageScans do
  use Ecto.Migration

  def change do
    create table(:storage_scans, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :file_system_name, references(:storage_file_systems, column: :name, type: :string, on_delete: :delete_all),
        null: false

      add :results, :map, default: %{}

      timestamps()
      add :completed_at, :naive_datetime
    end
  end
end
