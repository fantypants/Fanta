defmodule FantaWeb.Models.Mission do
  use Ecto.Schema
  import Ecto.Changeset
  alias FantaWeb.Models.Mission

  schema "missions" do
    field :name, :string
    belongs_to :user, Fanta.Accounts.User, foreign_key: :user_id
    has_many :questions, FantaWeb.Models.Question

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :user_id])
    |> cast_assoc(:questions)
    |> validate_required([:name, :user_id])
  end
end
