defmodule ExPoll.Polls do
  @moduledoc """
  The Polls context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias ExPoll.Repo
  alias ExPoll.Polls.{Poll, Option, Vote}

  # POLL

  def list_polls do
    Repo.all(Poll)
  end

  def get_poll!(id) do
    query =
      from p in Poll,
        where: p.id == ^id,
        preload: [options: ^options_query()]

    Repo.one!(query)
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

  def publish_poll(%Poll{} = poll) do
    poll
    |> Poll.publish_changeset()
    |> Repo.update()
  end

  def unpublish_poll(%Poll{} = poll) do
    poll_changeset = Poll.unpublish_changeset(poll)
    option_ids = Enum.map(poll.options, fn option -> option.id end)
    poll_votes_query = from(v in Vote, where: v.option_id in ^option_ids)

    result =
      Multi.new()
      |> Multi.update(:update_poll, poll_changeset)
      |> Multi.delete_all(:delete_votes, poll_votes_query)
      |> Repo.transaction()

    case result do
      {:ok, %{update_poll: poll}} ->
        {:ok, get_poll!(poll.id)}

      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        {:error, "Something went wrong while unpublishing a poll"}
    end
  end

  def change_poll(%Poll{} = poll, attrs \\ %{}) do
    Poll.changeset(poll, attrs)
  end

  # OPTION

  def options_query do
    from o in Option,
      left_join: v in assoc(o, :votes),
      group_by: o.id,
      select_merge: %{vote_count: count(v.id)}
  end

  def get_option!(id) do
    query =
      from o in options_query(),
        where: o.id == ^id,
        preload: [:poll]

    Repo.one!(query)
  end

  def create_option(%Poll{} = poll, attrs \\ %{}) do
    poll
    |> Ecto.build_assoc(:options, poll: poll)
    |> Option.changeset(attrs)
    |> Repo.insert()
  end

  def update_option(%Option{} = option, attrs) do
    option
    |> Option.changeset(attrs)
    |> Repo.update()
  end

  def delete_option(%Option{} = option) do
    option
    |> change_option()
    |> Repo.delete()
  end

  def change_option(%Option{} = option, attrs \\ %{}) do
    Option.changeset(option, attrs)
  end

  # VOTE

  def create_vote(%Option{} = option) do
    option
    |> Ecto.build_assoc(:votes, option: option)
    |> change_vote()
    |> Repo.insert()
  end

  def change_vote(%Vote{} = vote, attrs \\ %{}) do
    Vote.changeset(vote, attrs)
  end
end
