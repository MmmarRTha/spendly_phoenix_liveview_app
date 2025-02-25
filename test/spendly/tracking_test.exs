defmodule Spendly.TrackingTest do
  use Spendly.DataCase

  alias Spendly.Tracking

  describe "budgets" do
    alias Spendly.Tracking.Budget

    test "create_budget/2 with valid data creates budget" do
      user = Spendly.AccountsFixtures.user_fixture()

      valid_attrs = %{
        name: "some name",
        description: "some description",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-02-28],
        creator_id: user.id
      }

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert budget.name == "some name"
      assert budget.description == "some description"
      assert budget.start_date == ~D[2025-01-01]
      assert budget.end_date == ~D[2025-02-28]
      assert budget.creator_id == user.id
    end

    test "create_budget/2 requires name" do
      user = Spendly.AccountsFixtures.user_fixture()

      attrs_without_name = %{
        description: "some description",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-02-28],
        creator_id: user.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(attrs_without_name)

      assert changeset.valid? == false
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "create_budget/2 requires valid dates" do
      user = Spendly.AccountsFixtures.user_fixture()

      attrs_end_before_start = %{
        name: "some name",
        description: "some description",
        start_date: ~D[2025-12-01],
        end_date: ~D[2025-02-28],
        creator_id: user.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Tracking.create_budget(attrs_end_before_start)

      assert changeset.valid? == false
      assert %{end_date: ["must end after start date"]} = errors_on(changeset)
    end
  end
end
