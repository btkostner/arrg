defmodule Arrg.Repo do
  use Ecto.Repo,
    otp_app: :arrg,
    adapter: Ecto.Adapters.SQLite3
end
