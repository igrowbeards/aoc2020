defmodule DaySixTest do
  use ExUnit.Case

  test "count_groups" do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    assert DaySix.count_groups(input, &DaySix.count_total_affirmative/1) == 11
  end

  test "count_groups strict" do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    assert DaySix.count_groups(input, &DaySix.count_group_affirmative/1) == 6
  end

  test "run_p1" do
    assert DaySix.run_p1() == 6612
  end

  test "run_p2" do
    assert DaySix.run_p2() == 3268
  end
end
