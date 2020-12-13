defmodule DayElevenTest do
  use ExUnit.Case

  # @tag :skip
  test "blah" do
    input = """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """

    expected = """
    #.##.##.##
    #######.##
    #.#.#..#..
    ####.##.##
    #.##.##.##
    #.#####.##
    ..#.#.....
    ##########
    #.######.#
    #.#####.##
    """
    |> String.trim()

    actual = 
      input
      |> DayEleven.parse_input()
      |> DayEleven.mutate_seating()
      |> DayEleven.seating_list_to_string(10)

    assert actual == expected

    round_two = """
    #.LL.L#.##
    #LLLLLL.L#
    L.L.L..L..
    #LLL.LL.L#
    #.LL.LL.LL
    #.LLLL#.##
    ..L.L.....
    #LLLLLLLL#
    #.LLLLLL.L
    #.#LLLL.##
    """
    |> String.trim()

    actual = 
      actual
      |> DayEleven.parse_input()
      |> DayEleven.mutate_seating()
      |> DayEleven.seating_list_to_string(10)

    assert actual == round_two
  end

  test "get_nearest_seats" do
    input = """
    .......#.
    ...#.....
    .#.......
    .........
    ..#L....#
    ....#....
    .........
    #........
    ...#.....
    """
    |> String.trim()
    |> DayEleven.parse_input()

    assert ["#", "#", "#", "#", "#", "#", "#", "#"] = DayEleven.get_nearest_seats(input, {4, 3})
  end

  # @tag :skip
  test "get_surrounding_seats" do
    input = %{
      {0, 0} => "nw",
      {0, 1} => "n",
      {0, 2} => "ne",
      {1, 0} => "w",
      {1, 1} => "target",
      {1, 2} => "e",
      {2, 0} => "sw",
      {2, 1} => "s",
      {2, 2} => "se"
    }

    assert ["nw", "n", "ne", "w", "e", "sw", "s", "se"] = DayEleven.get_surrounding_seats(input, {1, 1})

    input = %{
      {0, 0} => "target",
      {0, 1} => "e",
      {0, 2} => "not_used_a",
      {1, 0} => "s",
      {1, 1} => "se",
      {1, 2} => "not_used_b",
      {2, 0} => "not_used_c",
      {2, 1} => "not_used_d",
      {2, 2} => "not_used_e"
    }

    assert [nil, nil, nil, nil, "e", nil, "s", "se"] = DayEleven.get_surrounding_seats(input, {0, 0})

    input = %{
      {0, 0} => "",
      {0, 1} => "",
      {0, 2} => "",
      {1, 0} => "",
      {1, 1} => "nw",
      {1, 2} => "n",
      {2, 0} => "",
      {2, 1} => "w",
      {2, 2} => "target"
    }

    assert ["nw", "n", nil, "w", nil, nil, nil, nil] = DayEleven.get_surrounding_seats(input, {2, 2})

    input = %{
      {0, 0} => "",
      {0, 1} => "",
      {0, 2} => "",
      {1, 0} => "n",
      {1, 1} => "ne",
      {1, 2} => "",
      {2, 0} => "target",
      {2, 1} => "e",
      {2, 2} => ""
    }

    assert [nil, "n", "ne", nil, "e", nil, nil, nil] = DayEleven.get_surrounding_seats(input, {2, 0})
  end

  # @tag :skip
  test "mutate_seat" do
    assert DayEleven.mutate_seat("L", ["L", "L", "L", "L", "L", "L", "L", "L"]) == "#"

    assert DayEleven.mutate_seat("#", ["#", "#", "#", "#", "L", "L", "L", "L"]) == "L"
  end

  # @tag :skip
  test "mutate until dupe" do
    results = """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
    |> String.trim()
    |> DayEleven.parse_input()
    |> DayEleven.mutate_seating_until_dupe()

    assert results == 37
  end

  # @tag :skip
  test "mutate until dupe picky" do
    results = """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """
    |> String.trim()
    |> DayEleven.parse_input()
    |> DayEleven.mutate_seating_until_dupe_picky()

    assert results == 26
  end
end
