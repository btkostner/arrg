defmodule Arrg.Storage do
  @moduledoc """
  An abstract storage implementation that allows cross implementation
  logic. This allows us to mock out the storage for testing, as well as
  support other storage like backends (e.g. S3).
  """

  import Ecto.Query

  alias Arrg.Repo
  alias Arrg.Storage.FileSystem
  alias Arrg.Storage.ScanProcess
  alias Arrg.Storage.Scan

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

  @doc """
  Returns all of the known scans.

  ## Examples

      iex> list_scans()
      [%Scan{}, ...]

  """
  def list_scans do
    Scan
    |> Repo.all()
    |> Repo.preload([:file_system])
    |> Scan.populate_fields()
  end

  @doc """
  Returns the list of scans for the given file system.

  ## Examples

      iex> list_file_system_scans(file_system)
      [%Scan{}, ...]

      iex> list_file_system_scans("local")
      [%Scan{}, ...]

  """
  def list_file_system_scans(%FileSystem{name: name}),
    do: list_file_system_scans(name)

  def list_file_system_scans(file_system) when is_binary(file_system) do
    Scan
    |> where([s], s.file_system == ^file_system)
    |> Repo.all()
    |> Repo.preload([:file_system])
    |> Scan.populate_fields()
  end

  @doc """
  Gets a single scan.

  Raises if the scan does not exist.

  ## Examples

      iex> get_scan!(scan_uuid)
      %Scan{}

  """
  def get_scan!(id) do
    Scan
    |> Repo.get!(id)
    |> Repo.preload([:file_system])
    |> Scan.populate_fields()
  end

  @doc """
  Creates a new scan of a file system. This will insert the initial record
  into the database, as well as spawn the scan process.

  Only one scan can be running at a time. This will return the latest scan
  if it's still running.

  ## Examples

      iex> create_file_system(%{name: value})
      {:ok, %FileSystem{}}

      iex> create_file_system(%{name: bad_value})
      {:error, ...}

  """
  def create_scan(attrs \\ %{}) do
    %Scan{}
    |> Scan.changeset(attrs)
    |> Repo.insert()
    |> then(fn
      {:ok, scan} ->
        scan = Repo.preload(scan, [:file_system])
        ScanProcess.create(scan.file_system)
        {:ok, Scan.populate_fields(scan)} |> IO.inspect(label: "populated data")

      other ->
        other
    end)
  end

  @doc """
  Updates the database scan record.

  ## Examples

      iex> update_scan(scan, %{completed_at: new_value})
      {:ok, %Scan{}}

      iex> update_scan(scan, %{completed_at: bad_value})
      {:error, ...}

  """
  def update_scan(%Scan{} = scan, attrs) do
    scan
    |> Scan.changeset(attrs)
    |> Repo.update()
    |> then(fn
      {:ok, scan} ->
        {:ok, Scan.populate_fields(scan)}

      other ->
        other
    end)
  end

  @doc """
  Returns a data structure for tracking scan changes.

  ## Examples

      iex> change_scan(scan)
      %Ecto.Changeset{...}

  """
  def change_scan(%Scan{} = scan, attrs \\ %{}) do
    Scan.changeset(scan, attrs)
  end
end
