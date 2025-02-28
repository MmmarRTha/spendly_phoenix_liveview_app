defmodule SpendlyWeb.Live.BudgetListLiveTest do
  alias Spendly.Tracking
  use SpendlyWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Spendly.TrackingFixtures

  setup do
    user = Spendly.AccountsFixtures.user_fixture()

    %{user: user}
  end

  describe "Index view" do
    test "shows budget when one exists", %{conn: conn, user: user} do
      budget = budget_fixture(%{creator_id: user.id})

      conn = log_in_user(conn, user)
      {:ok, _lv, html} = live(conn, ~p"/budgets")

      assert html =~ budget.name
      assert html =~ budget.description
    end
  end

  describe "Create budget modal" do
    test "modal is presented", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      assert has_element?(lv, "#create-budget-modal")
    end

    test "shows an error when budget name is empty", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      form = element(lv, "#create-budget-modal form")

      html =
        render_change(form, %{
          "budget" => %{"name" => ""}
        })

      assert html =~ html_escape("can't be blank")
    end

    test "creates a budget", %{conn: conn, user: user} do
      conn = log_in_user(conn, user)
      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      form = form(lv, "#create-budget-modal form")

      {:ok, _lv, html} =
        render_submit(form, %{
          "budget" => %{
            "name" => "A New Name",
            "description" => "The New Description",
            "start_date" => "2025-02-27",
            "end_date" => "2025-02-28"
          }
        })
        |> follow_redirect(conn)

      assert html =~ "Budget created"
      assert html =~ "A New Name"

      assert [created_budget] = Tracking.list_budgets()
      assert created_budget.name == "A New Name"
      assert created_budget.description == "The New Description"
      assert created_budget.start_date == ~D[2025-02-27]
      assert created_budget.end_date == ~D[2025-02-28]
    end
  end
end
