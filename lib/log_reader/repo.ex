defmodule LogReader.Repo do
  use Ecto.Repo,
    otp_app: :log_reader,
    adapter: Ecto.Adapters.Postgres
end
