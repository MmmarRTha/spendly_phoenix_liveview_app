defmodule Spendly.GuardsTest do
  use ExUnit.Case, async: true

  import Spendly.Guards

  describe "is_uuid" do
    test "True when the string is a UUID" do
      assert is_uuid("550e8400-e29b-41d4-a716-446655440000")
    end
  end

  test "False when the string is not a UUID" do
    refute is_uuid("martha")
  end
end
