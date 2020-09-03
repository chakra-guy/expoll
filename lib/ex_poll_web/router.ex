defmodule ExPollWeb.Router do
  use ExPollWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExPollWeb do
    pipe_through :api

    resources "/polls", PollController, except: [:new, :edit] do
      resources "/options", OptionController, except: [:new, :edit]
    end

    post("/polls/:id/vote", VoteController, :create)
    post("/polls/:id/publish", PollController, :publish)
    post("/polls/:id/unpublish", PollController, :unpublish)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ExPollWeb.Telemetry
    end
  end
end
