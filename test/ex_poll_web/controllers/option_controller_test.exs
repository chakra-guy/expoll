defmodule ExPollWeb.OptionControllerTest do
  use ExPollWeb.ConnCase

  alias ExPoll.Polls
  alias ExPoll.Polls.Option

  @create_poll_attrs %{question: "some question"}
  @create_option_attrs %{value: "some value"}
  @invalid_option_attrs %{value: nil}
  @update_option_attrs %{value: "some updated value"}

  def fixture(:poll) do
    {:ok, poll} = Polls.create_poll(@create_poll_attrs)
    poll
  end

  def fixture(:option) do
    {:ok, poll} = Polls.create_poll(@create_poll_attrs)
    {:ok, poll_option} = Polls.create_option(poll, @create_option_attrs)
    poll_option
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all options", %{conn: conn} do
      poll = fixture(:poll)
      conn = get(conn, Routes.poll_option_path(conn, :index, poll.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create option" do
    test "renders option when data is valid", %{conn: conn} do
      poll = fixture(:poll)

      conn =
        post(conn, Routes.poll_option_path(conn, :create, poll.id), option: @create_option_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.poll_option_path(conn, :show, poll.id, id))

      assert %{
               "id" => id,
               "value" => "some value"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      poll = fixture(:poll)

      conn =
        post(conn, Routes.poll_option_path(conn, :create, poll.id), option: @invalid_option_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update option" do
    test "renders option when data is valid", %{conn: conn} do
      %Option{id: id, poll_id: poll_id} = fixture(:option)

      conn =
        put(conn, Routes.poll_option_path(conn, :update, poll_id, id),
          option: @update_option_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.poll_option_path(conn, :show, poll_id, id))

      assert %{
               "id" => id,
               "value" => "some updated value"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %Option{id: id, poll_id: poll_id} = fixture(:option)

      conn =
        put(conn, Routes.poll_option_path(conn, :update, poll_id, id),
          option: @invalid_option_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete option" do
    test "deletes chosen option", %{conn: conn} do
      %Option{id: id, poll_id: poll_id} = fixture(:option)
      conn = delete(conn, Routes.poll_option_path(conn, :delete, poll_id, id))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.poll_option_path(conn, :show, poll_id, id))
      end
    end
  end
end
