defmodule Arrg.Storage.ImplementationBehaviour do
  @moduledoc """
  A behaviour for file system storage implementations. This allows us to
  mock out the file system for testing, as well as implement other
  file system like backends (e.g. S3).
  """

  @type config :: struct()

  @callback changeset(config(), map()) :: Ecto.Changeset.t()

  @callback friendly_name() :: String.t()

  @callback scan(config(), String.t(), Keyword.t()) :: {:ok, Enumerable.t()} | {:error, any}

  @callback read(config(), String.t(), Keyword.t()) :: {:ok, Enumerable.t()} | {:error, any}

  @callback write(Enumerable.t(), config(), String.t(), Keyword.t()) :: :ok | {:error, any}

  @callback delete(config(), String.t(), Keyword.t()) :: :ok | {:error, any}
end
