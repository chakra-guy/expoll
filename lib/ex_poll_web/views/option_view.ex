defmodule ExPollWeb.OptionView do
  use ExPollWeb, :view
  alias ExPollWeb.OptionView

  def render("index.json", %{options: options}) do
    %{data: render_many(options, OptionView, "option.json")}
  end

  def render("show.json", %{option: option}) do
    %{data: render_one(option, OptionView, "option.json")}
  end

  def render("option.json", %{option: option}) do
    %{
      id: option.id,
      value: option.value,
      vote_count: option.vote_count
    }
  end
end
