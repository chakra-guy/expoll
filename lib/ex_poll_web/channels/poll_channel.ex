defmodule ExPollWeb.PollChannel do
  use ExPollWeb, :channel

  def join("poll:" <> _poll_id, _payload, socket) do
    {:ok, socket}
  end
end
