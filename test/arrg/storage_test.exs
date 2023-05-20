defmodule Arrg.StorageTest do
  use Arrg.DataCase, async: true

  alias Arrg.Storage

  describe "FileSystem" do
    alias Arrg.Storage.FileSystem

    import Arrg.StorageFixtures

    @invalid_attrs %{name: nil}

    test "list_file_systems/0 returns all file systems" do
      file_system = insert(:file_system)
      assert Storage.list_file_systems() == [file_system]
    end

    test "get_file_system!/1 returns the file system with given name" do
      file_system = insert(:file_system)
      assert Storage.get_file_system!(file_system.name) == file_system
    end

    test "create_file_system/1 with valid data creates a file system" do
      valid_name = "test name"
      valid_attrs = params_for(:file_system, name: valid_name)

      assert {:ok, %FileSystem{} = file_system} = Storage.create_file_system(valid_attrs)
      assert file_system.name == valid_name
    end

    test "create_file_system/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Storage.create_file_system(@invalid_attrs)
    end

    test "update_file_system/2 with valid data updates the setting" do
      file_system = insert(:file_system)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %FileSystem{} = file_system} = Storage.update_file_system(file_system, update_attrs)
      assert file_system.name == "some updated name"
    end

    test "update_file_system/2 with invalid data returns error changeset" do
      file_system = insert(:file_system)
      assert {:error, %Ecto.Changeset{}} = Storage.update_file_system(file_system, @invalid_attrs)
      assert file_system == Storage.get_file_system!(file_system.name)
    end

    test "delete_file_system/1 deletes the file system" do
      file_system = insert(:file_system)
      assert {:ok, %FileSystem{}} = Storage.delete_file_system(file_system)
      assert_raise Ecto.NoResultsError, fn -> Storage.get_file_system!(file_system.name) end
    end

    test "change_file_system/1 returns a file system changeset" do
      file_system = build(:file_system)
      assert %Ecto.Changeset{} = Storage.change_file_system(file_system)
    end
  end
end
