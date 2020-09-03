defmodule ExPoll.Polls.Poll do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExPoll.Polls.Option

  schema "polls" do
    field :question, :string
    field :is_published, :boolean, default: false
    timestamps()

    has_many(:options, Option, on_replace: :delete)
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:question])
    |> cast_assoc(:options)
    |> validate_required([:question])
    |> validate_poll_is_not_published()
  end

  def publish_changeset(poll) do
    poll
    |> cast(%{is_published: true}, [:is_published])
    |> validate_min_options_count()
  end

  def unpublish_changeset(poll) do
    poll
    |> cast(%{is_published: false}, [:is_published])
  end

  defp validate_poll_is_not_published(changeset) do
    is_published = get_field(changeset, :is_published)

    case is_published do
      true -> add_error(changeset, :is_published, "poll can't be modified when it's published")
      false -> changeset
    end
  end

  defp validate_min_options_count(changeset, count \\ 2) do
    options = get_field(changeset, :options, [])

    case length(options) >= count do
      true -> changeset
      false -> add_error(changeset, :options, "should have at least #{count} option(s)")
    end
  end
end
