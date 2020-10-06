defmodule ExPollWeb.VoteView do
  use ExPollWeb, :view
  alias ExPollWeb.VoteView

  def render("show.json", %{vote: vote}) do
    %{data: render_one(vote, VoteView, "vote.json")}
  end

  def render("vote.json", %{vote: vote}) do
    %{id: vote.id}
  end
end
