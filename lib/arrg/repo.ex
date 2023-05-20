defmodule Arrg.Repo do
  @moduledoc """
  An `Ecto.Repo` instance for the Arrg application.
  """

  use Ecto.Repo,
    otp_app: :arrg,
    adapter: Ecto.Adapters.SQLite3
end
