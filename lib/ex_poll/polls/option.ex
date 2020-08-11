defmodule ExPoll.Polls.Option do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExPoll.Polls.Poll

  schema "options" do
    field :value, :string
    timestamps()

    belongs_to(:poll, Poll)
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [:value])
    |> validate_required([:value])
    |> assoc_constraint(:poll)
  end
end
