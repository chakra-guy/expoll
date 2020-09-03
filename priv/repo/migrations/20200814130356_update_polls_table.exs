defmodule ExPoll.Repo.Migrations.UpdatePollsTable do
  use Ecto.Migration

  def change do
    alter table(:polls) do
      add :is_published, :boolean, default: false
    end
  end
end
