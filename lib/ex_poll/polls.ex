defmodule ExPoll.Polls do
  @moduledoc """
  The Polls context.
  """

  import Ecto.Query, warn: false
  alias ExPoll.Repo

  alias ExPoll.Polls.{Poll, Option}

  # POLL

  defp poll_with_options_query(id) do
    from p in Poll,
      where: p.id == ^id,
      preload: [options: ^options_query()]
  end

  def list_polls do
    Repo.all(Poll)
  end

  def get_poll!(id) do
    id
    |> poll_with_options_query()
    |> Repo.one!()
  end

  def create_poll(attrs \\ %{}) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %Poll{} = poll} -> {:ok, Repo.preload(poll, options: options_query())}
      error -> error
    end
  end

  def update_poll(%Poll{} = poll, attrs) do
    poll
    |> Poll.changeset(attrs)
    |> Repo.update()
  end

  def delete_poll(%Poll{} = poll) do
    Repo.delete(poll)
  end

  def change_poll(%Poll{} = poll, attrs \\ %{}) do
    Poll.changeset(poll, attrs)
  end

  # OPTION

  defp options_query do
    from o in Option,
      left_join: v in assoc(o, :votes),
      group_by: o.id,
      select_merge: %{vote_count: count(v.id)}
  end

  defp option_query(id) do
    from o in options_query(),
      where: o.id == ^id
  end

  def get_option!(id) do
    id
    |> option_query()
    |> Repo.one!()
  end

  def create_option(%Poll{} = poll, attrs \\ %{}) do
    poll
    |> Ecto.build_assoc(:options)
    |> Option.changeset(attrs)
    |> Repo.insert()
  end

  def update_option(%Option{} = option, attrs) do
    option
    |> Option.changeset(attrs)
    |> Repo.update()
  end

  def delete_option(%Option{} = option) do
    Repo.delete(option)
  end

  def change_option(%Option{} = option, attrs \\ %{}) do
    Option.changeset(option, attrs)
  end

  # VOTE

  def create_vote(%Option{} = option) do
    option
    |> Ecto.build_assoc(:votes)
    |> Repo.insert()
  end
end
