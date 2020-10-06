defmodule ExPoll.Repo.Migrations.CreatePolls do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :question, :string, null: false

      timestamps()
    end
  end
end
