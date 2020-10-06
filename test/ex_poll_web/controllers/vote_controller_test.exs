defmodule ExPollWeb.VoteControllerTest do
  use ExPollWeb.ConnCase

  alias ExPoll.Polls
  alias ExPoll.Polls.Option
  alias ExPollWeb.Endpoint

  @create_poll_attrs %{question: "some question"}
  @create_option_attrs %{value: "some value"}

  def fixture(:option) do
    {:ok, poll} = Polls.create_poll(@create_poll_attrs)
    {:ok, poll_option} = Polls.create_option(poll, @create_option_attrs)
    poll_option
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create vote" do
    test "when data is valid renders vote, updates vote count and broadcast new vote", %{
      conn: conn
    } do
      %Option{id: id, poll_id: poll_id} = fixture(:option)

      Endpoint.subscribe("poll:#{poll_id}")

      conn = post(conn, Routes.vote_path(conn, :create, poll_id), vote: %{option_id: id})

      assert %{"id" => _} = json_response(conn, 201)["data"]
      assert_receive %Phoenix.Socket.Broadcast{event: "new_vote", payload: %{option_id: id}}

      conn = get(conn, Routes.poll_option_path(conn, :show, poll_id, id))

      assert %{"vote_count" => 1} = json_response(conn, 200)["data"]

      Endpoint.unsubscribe("poll:#{poll_id}")
    end
  end
end
