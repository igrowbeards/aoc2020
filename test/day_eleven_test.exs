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
      |> DayEleven.seating_list_to_string() 

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
      |> DayEleven.seating_list_to_string() 

    assert actual == round_two
  end

  # @tag :skip
  test "get_surrounding_seats" do
    input = [
      ["nw", "n", "ne"],
      ["w", "target", "e"],
      ["sw", "s", "se"]
    ]

    assert ["nw", "n", "ne", "w", "e", "sw", "s", "se"] = DayEleven.get_surrounding_seats(input, 1, 1)

    input = [
      ["target", "e",  "not_used_a"],
      ["s",      "se", "not_used_b"],
      ["not_used_c",      "not_used_d",  "not_used_e"]
    ]

    assert [nil, nil, nil, nil, "e", nil, "s", "se"] = DayEleven.get_surrounding_seats(input, 0, 0)

    input = [
      ["", "", ""],
      ["", "nw", "n"],
      ["", "w", "target"]
    ]

    assert ["nw", "n", nil, "w", nil, nil, nil, nil] = DayEleven.get_surrounding_seats(input, 2, 2)

    input = [
      ["", "", ""],
      ["n", "ne", ""],
      ["target", "e", ""]
    ]

    assert [nil, "n", "ne", nil, "e", nil, nil, nil] = DayEleven.get_surrounding_seats(input, 2, 0)
  end

  # @tag :skip
  test "mutate_seat" do
    assert DayEleven.mutate_seat("L", ["L", "L", "L", "L", "L", "L", "L", "L"]) == "#"

    assert DayEleven.mutate_seat("#", ["#", "#", "#", "#", "L", "L", "L", "L"]) == "L"
  end
end
