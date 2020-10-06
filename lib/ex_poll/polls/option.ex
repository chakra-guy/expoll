defmodule ExPoll.Polls.Option do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExPoll.Polls.{Poll, Vote}

  schema "options" do
    field :value, :string
    field :vote_count, :integer, default: 0, virtual: true
    timestamps()

    belongs_to(:poll, Poll)
    has_many(:votes, Vote)
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [:value])
    |> validate_required([:value])
    |> assoc_constraint(:poll)
  end
end
