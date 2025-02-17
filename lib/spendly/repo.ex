defmodule Spendly.Repo do
  use Ecto.Repo,
    otp_app: :spendly,
    adapter: Ecto.Adapters.Postgres
end
