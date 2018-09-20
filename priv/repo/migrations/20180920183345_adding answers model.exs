defmodule :"Elixir.Fanta.Repo.Migrations.Adding answers model" do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :body, {:array, :string}
      add :question_id, references(:questions, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create index(:answers, [:question_id])
    create index(:answers, [:user_id])
  end
end
