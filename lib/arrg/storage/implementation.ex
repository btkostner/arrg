defmodule Arrg.Storage.Implementation do
  @moduledoc """
  A behaviour for file system storage implementations. This allows us to
  mock out the file system for testing, as well as implement other
  file system like backends (e.g. S3).
  """

  alias Arrg.Storage.File
  alias Arrg.Storage.FileSystem

  @doc """
  Returns a list of all the different implementations and their
  friendly name.
  """
  def types do
    [
      {"Local", Arrg.Storage.LocalImplementation}
    ]
  end

  @doc """
  Reads a file from the file system.
  """
  @spec read(FileSystem.t(), File.t() | File.path()) :: {:ok, Stream.t()} | {:error, any}
  def read(filesystem, file, opts \\ [])

  def read(%FileSystem{} = filesystem, %File{path: path}, opts),
    do: read(filesystem, path, opts)

  def read(%FileSystem{implementation: %implementation{} = config}, path, opts),
    do: implementation.read(config, path, opts)

  @doc """
  Writes a stream to a file.
  """
  @spec write(Stream.t(), FileSystem.t(), File.t() | File.path(), Keyword.t()) ::
          :ok | {:error, any}
  def write(stream, filesystem, file, opts \\ [])

  def write(%Stream{} = stream, %FileSystem{} = filesystem, %File{path: path}, opts),
    do: write(stream, filesystem, path, opts)

  def write(
        %Stream{} = stream,
        %FileSystem{implementation: %implementation{} = config},
        path,
        opts
      ),
      do: implementation.write(stream, config, path, opts)

  @doc """
  Deletes a file on the file system.
  """
  @spec delete(FileSystem.t(), File.t() | File.path(), Keyword.t()) :: :ok | {:error, any}
  def delete(filesystem, file, opts \\ [])

  def delete(%FileSystem{} = filesystem, %File{path: path}, opts),
    do: delete(filesystem, path, opts)

  def delete(%FileSystem{implementation: %implementation{} = config}, path, opts),
    do: implementation.delete(config, path, opts)
end
