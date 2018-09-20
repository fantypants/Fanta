defmodule :"Elixir.Fanta.Repo.Migrations.Adding Missions & Question" do
  use Ecto.Migration

  def change do
    create table(:missions) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()

  end

  create table(:questions) do
    add :title, :string
    add :type, :string
    add :options, {:array, :string}
    add :mission_id, references(:missions, on_delete: :nothing)

    timestamps()
  end

    create index(:missions, [:user_id])
    create index(:questions, [:mission_id])
  end
end
