defmodule ExPoll.Polls.Poll do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExPoll.Polls.Option

  schema "polls" do
    field :question, :string
    timestamps()

    has_many(:options, Option, on_replace: :delete)
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:question])
    |> cast_assoc(:options)
    |> validate_required([:question])
  end
end
