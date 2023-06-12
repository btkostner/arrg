defmodule Arrg.Repo.Migrations.CreateStorageFileSystems do
  use Ecto.Migration

  def change do
    create table(:storage_file_systems, primary_key: false) do
      add :name, :string, primary_key: true
      add :implementation, :jsonb, null: false

      timestamps()
    end

    create table(:storage_files, primary_key: false) do
      add :file_system_name,
          references(:storage_file_systems, column: :name, type: :string, on_delete: :delete_all, on_update: :update_all),
          primary_key: true

      add :path, :string, primary_key: true
      add :mime_type, :string

      add :scanned_at, :utc_datetime
      timestamps()
    end
  end
end
