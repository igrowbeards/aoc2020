defmodule DayTenTest do
  use ExUnit.Case

  test "run_p1" do
    input = """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """
    assert DayTen.calculate_joltage_differences(input) == 220
  end

  test "p2" do
    # input = """
    # 28
    # 33
    # 18
    # 42
    # 31
    # 14
    # 46
    # 20
    # 48
    # 47
    # 24
    # 23
    # 49
    # 45
    # 19
    # 38
    # 39
    # 11
    # 1
    # 32
    # 25
    # 35
    # 8
    # 17
    # 7
    # 9
    # 4
    # 2
    # 34
    # 10
    # 3
    # """
  end

  test "run_p2" do
    input = """
    1
    4
    5
    6
    7
    10
    11
    12
    15
    16
    19
    """

    assert DayTen.calculate_possible_combinations(input) == 8
  end
end
