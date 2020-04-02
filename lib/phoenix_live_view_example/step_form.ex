defmodule PhoenixLiveViewExample.StepForm do
  use Ecto.Schema
  import Ecto.Changeset

  schema "step_form" do
    field :title, :string
    field :description, :string

    field :type, :string, default: "thing_a"

    field :something_else, :string
  end

  def changeset(example, attrs) do
    example
    |> cast(attrs, [:title, :description, :type, :something_else])
    |> validate_required([:title, :description, :type, :something_else])
    |> validate_length(:title, max: 20)
    |> validate_length(:description, min: 10, max: 500)
    |> validate_inclusion(:type, ["thing_a", "thing_b"])
  end
end
