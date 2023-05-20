defmodule Arrg.Storage do
  @moduledoc """
  An abstract storage implementation that allows cross implementation
  logic. This allows us to mock out the storage for testing, as well as
  support other storage like backends (e.g. S3).
  """

  alias Arrg.Repo
  alias Arrg.Storage.FileSystem

  @doc """
  Returns the list of storage file systems.

  ## Examples

      iex> list_file_systems()
      [%FileSystem{}, ...]

  """
  def list_file_systems do
    Repo.all(FileSystem)
  end

  @doc """
  Gets a single storage file system.

  Raises if the file system does not exist.

  ## Examples

      iex> get_file_system!("music")
      %FileSystem{}

  """
  def get_file_system!(name), do: Repo.get!(FileSystem, name)

  @doc """
  Creates a storage file system.

  ## Examples

      iex> create_file_system(%{name: value})
      {:ok, %FileSystem{}}

      iex> create_file_system(%{name: bad_value})
      {:error, ...}

  """
  def create_file_system(attrs \\ %{}) do
    %FileSystem{}
    |> FileSystem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a file system.

  ## Examples

      iex> update_file_system(file_system, %{name: new_value})
      {:ok, %FileSystem{}}

      iex> update_file_system(file_system, %{name: bad_value})
      {:error, ...}

  """
  def update_file_system(%FileSystem{} = file_system, attrs) do
    file_system
    |> FileSystem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a file systems.

  ## Examples

      iex> delete_file_system(file_system)
      {:ok, %FileSystem{}}

      iex> delete_file_system(file_system)
      {:error, ...}

  """
  def delete_file_system(%FileSystem{} = file_system) do
    Repo.delete(file_system)
  end

  @doc """
  Returns a data structure for tracking setting changes.

  ## Examples

      iex> change_file_system(file_system)
      %Ecto.Changeset{...}

  """
  def change_file_system(%FileSystem{} = file_system, attrs \\ %{}) do
    FileSystem.changeset(file_system, attrs)
  end
end
