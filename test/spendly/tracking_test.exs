defmodule Spendly.TrackingTest do
  use Spendly.DataCase

  import Spendly.TrackingFixtures

  alias Spendly.Tracking

  describe "budgets" do
    alias Spendly.Tracking.Budget

    test "create_budget/2 with valid data creates budget" do
      user = Spendly.AccountsFixtures.user_fixture()

      valid_attrs = valid_budget_attributes(%{creator_id: user.id})

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert budget.name == "some name"
      assert budget.description == "some description"
      assert budget.start_date == ~D[2025-01-01]
      assert budget.end_date == ~D[2025-02-28]
      assert budget.creator_id == user.id
    end

    test "create_budget/2 requires name" do
      attrs =
        valid_budget_attributes()
        |> Map.delete(:name)

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(attrs)

      assert changeset.valid? == false
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "create_budget/2 requires valid dates" do
      attrs =
        valid_budget_attributes()
        |> Map.merge(%{
          start_date: ~D[2025-12-01],
          end_date: ~D[2025-02-28]
        })

      assert {:error, %Ecto.Changeset{} = changeset} =
               Tracking.create_budget(attrs)

      assert changeset.valid? == false
      assert %{end_date: ["must end after start date"]} = errors_on(changeset)
    end

    test "list_budgets/0 returns all budgets" do
      budget = budget_fixture()
      assert Tracking.list_budgets() == [budget]
    end

    test "list_budgets/1 sco[es to the provided user" do
      user = Spendly.AccountsFixtures.user_fixture()
      budget = budget_fixture(%{creator_id: user.id})
      _other_budget = budget_fixture()

      assert Tracking.list_budgets(user: user) == [budget]
    end

    test "get_budget/1 returns the budget with the provided id" do
      budget = budget_fixture()

      assert Tracking.get_budget(budget.id) == budget
    end

    test "get_budget/1 returns nil if the budget does not exist" do
      _unrelated_budget = budget_fixture()
      assert is_nil(Tracking.get_budget("10fe1ad8-6133-5d7d-b5c9-da29581bb923"))
    end
  end
end
