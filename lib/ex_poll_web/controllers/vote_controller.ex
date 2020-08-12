defmodule ExPollWeb.VoteController do
  use ExPollWeb, :controller

  alias ExPoll.Polls
  alias ExPoll.Polls.Vote
  alias ExPollWeb.Endpoint

  action_fallback ExPollWeb.FallbackController

  def create(conn, %{"id" => id, "vote" => %{"option_id" => option_id}}) do
    option = Polls.get_option!(option_id)

    with {:ok, %Vote{} = vote} <- Polls.create_vote(option) do
      Endpoint.broadcast!("poll:" <> id, "new_vote", %{option_id: option.id})

      conn
      |> put_status(:created)
      |> render("show.json", vote: vote)
    end
  end
end
