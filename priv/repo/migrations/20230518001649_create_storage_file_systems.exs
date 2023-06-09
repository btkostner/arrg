defmodule Arrg.Repo.Migrations.CreateStorageFileSystems do
  use Ecto.Migration

  def change do
    create table(:storage_file_systems, primary_key: false) do
      add :name, :string, primary_key: true
      add :type, :string, null: false
      add :implementation, :jsonb, null: false

      timestamps()
    end

    create table(:storage_files, primary_key: false) do
      add :file_system, references(:storage_file_systems, column: :name, type: :string), primary_key: true
      add :path, :string, primary_key: true

      timestamps()
    end
  end
end
