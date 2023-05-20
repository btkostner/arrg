defmodule Arrg.Storage.ImplementationBehaviour do
  @moduledoc """
  A behaviour for file system storage implementations. This allows us to
  mock out the file system for testing, as well as implement other
  file system like backends (e.g. S3).
  """

  @type config :: struct()

  @callback changeset(config(), Map.t()) :: Ecto.Changeset.t()

  @callback friendly_name() :: String.t()

  @callback read(config(), File.path(), Keyword.t()) :: {:ok, Stream.t()} | {:error, any}

  @callback write(Stream.t(), config(), File.path(), Keyword.t()) :: :ok | {:error, any}

  @callback delete(config(), File.path(), Keyword.t()) :: :ok | {:error, any}
end
