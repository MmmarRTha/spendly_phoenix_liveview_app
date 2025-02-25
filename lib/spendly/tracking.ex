defmodule Spendly.Tracking do
  import Ecto.Query, warn: false

  alias Spendly.Repo
  alias Spendly.Tracking.Budget

  def create_budget(attrs \\ %{}) do
    %Budget{}
    |> Budget.changeset(attrs)
    |> Repo.insert()
  end

  def list_budgets, do: Repo.all(Budget)

  def get_budget(id), do: Repo.get(Budget, id)
end
