defmodule FantaWeb.Models.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias FantaWeb.Models.Question

  schema "questions" do
    field :title, :string
    field :type, :string
    field :options, {:array, :string}
    belongs_to :mission, FantaWeb.Models.Mission, foreign_key: :mission_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :type, :options, :mission_id])
    |> validate_required([:title, :type, :options, :mission_id])
  end
end
