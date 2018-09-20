defmodule FantaWeb.Models.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias FantaWeb.Models.Answer

  schema "answers" do
    field :body, {:array, :string}
    belongs_to :question, FantaWeb.Models.Question, foreign_key: :question_id
    belongs_to :user, Fanta.Accounts.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :question_id, :user_id])
    |> validate_required([:body, :question_id, :user_id])
  end
end
