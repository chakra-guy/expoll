defmodule ExPoll.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :option_id, references(:options, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:votes, [:option_id])
  end
end
