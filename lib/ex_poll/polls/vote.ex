defmodule ExPoll.Polls.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExPoll.Polls.Option

  schema "votes" do
    timestamps()

    belongs_to(:option, Option)
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [])
    |> validate_required([])
    |> validate_poll_is_published()
  end

  defp validate_poll_is_published(changeset) do
    option = get_field(changeset, :option)

    case option.poll.is_published do
      true -> changeset
      false -> add_error(changeset, :is_published, "poll can't be voted on when it's unpublished")
    end
  end
end
