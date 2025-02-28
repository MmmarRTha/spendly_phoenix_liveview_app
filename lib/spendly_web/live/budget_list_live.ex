defmodule SpendlyWeb.BudgetListLive do
  alias Spendly.Tracking
  use SpendlyWeb, :live_view

  def mount(_params, _session, socket) do
    budgets =
      Tracking.list_budgets(
        user: socket.assigns.current_user,
        preload: :creator
      )

    socket = assign(socket, budgets: budgets)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.modal
      :if={@live_action == :new}
      id="create-budget-modal"
      on_cancel={JS.navigate(~p"/budgets", replace: true)}
      show
    >
      <.live_component
        module={SpendlyWeb.BudgetCreateDialog}
        id="create-budget"
        current_user={@current_user}
      />
    </.modal>
    <div class="flex justify-end pb-5">
      <.link navigate={~p"/budgets/new"} class="text-white btn-sub">
        <.icon name="hero-plus" class="w-4 h-4 pt-5 pl-7" />
        <span>New Budget</span>
      </.link>
    </div>
    <.table id="budgets" rows={@budgets}>
      <:col :let={budget} label="Name">{budget.name}</:col>
      <:col :let={budget} label="Description">{budget.description}</:col>
      <:col :let={budget} label="Start Date">{budget.start_date}</:col>
      <:col :let={budget} label="End Date">{budget.end_date}</:col>
      <:col :let={budget} label="Creator Name">{budget.creator.name}</:col>
    </.table>
    """
  end
end
