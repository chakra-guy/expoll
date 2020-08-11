defmodule ExPoll.Repo do
  use Ecto.Repo,
    otp_app: :ex_poll,
    adapter: Ecto.Adapters.Postgres
end
