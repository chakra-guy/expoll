defmodule ExPoll.Repo.Migrations.CreateOptions do
  use Ecto.Migration

  def change do
    create table(:options) do
      add :value, :string, null: false
      add :poll_id, references(:polls, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:options, [:poll_id])
  end
end
