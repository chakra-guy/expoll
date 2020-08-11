defmodule ExPollWeb.OptionControllerTest do
  use ExPollWeb.ConnCase

  alias ExPoll.Polls
  alias ExPoll.Polls.Option

  @create_attrs %{
    value: "some value"
  }
  @update_attrs %{
    value: "some updated value"
  }
  @invalid_attrs %{value: nil}

  def fixture(:option) do
    {:ok, option} = Polls.create_option(@create_attrs)
    option
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all options", %{conn: conn} do
      conn = get(conn, Routes.option_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create option" do
    test "renders option when data is valid", %{conn: conn} do
      conn = post(conn, Routes.option_path(conn, :create), option: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.option_path(conn, :show, id))

      assert %{
               "id" => id,
               "value" => "some value"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.option_path(conn, :create), option: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update option" do
    setup [:create_option]

    test "renders option when data is valid", %{conn: conn, option: %Option{id: id} = option} do
      conn = put(conn, Routes.option_path(conn, :update, option), option: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.option_path(conn, :show, id))

      assert %{
               "id" => id,
               "value" => "some updated value"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, option: option} do
      conn = put(conn, Routes.option_path(conn, :update, option), option: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete option" do
    setup [:create_option]

    test "deletes chosen option", %{conn: conn, option: option} do
      conn = delete(conn, Routes.option_path(conn, :delete, option))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.option_path(conn, :show, option))
      end
    end
  end

  defp create_option(_) do
    option = fixture(:option)
    %{option: option}
  end
end
