defmodule SpendlyWeb.BudgetCreateDialog do
  use SpendlyWeb, :live_component

  alias Spendly.Tracking
  alias Spendly.Tracking.Budget

  @impl true
  def update(assigns, socket) do
    changeset = Tracking.change_budget(%Budget{})

    socket =
      socket
      |> assign(assigns)
      |> assign(form: to_form(changeset))

    {:ok, socket}
  end
end
