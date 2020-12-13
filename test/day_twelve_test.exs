defmodule DayTwelveTest do
  use ExUnit.Case

  alias DayTwelve, as: D12

  test "blah" do
    input = """
    F10
    N3
    F7
    R90
    F11
    """
    |> String.trim()

    assert D12.caluclate_distance(input) == 25
  end

  test "ship_follow_instruction - turning" do
    assert D12.ship_follow_instruction({"L", 90}, %{x: 0, y: 0, facing: :east}) == %{x: 0, y: 0, facing: :north}
    assert D12.ship_follow_instruction({"L", 180}, %{x: 0, y: 0, facing: :east}) == %{x: 0, y: 0, facing: :west}
    assert D12.ship_follow_instruction({"L", 270}, %{x: 0, y: 0, facing: :east}) == %{x: 0, y: 0, facing: :south}
    assert D12.ship_follow_instruction({"L", 360}, %{x: 0, y: 0, facing: :east}) == %{x: 0, y: 0, facing: :east}

    assert D12.ship_follow_instruction({"R", 90}, %{x: 0, y: 0, facing: :east}) == %{x: 0, y: 0, facing: :south}
    assert D12.ship_follow_instruction({"R", 180}, %{x: 0, y: 0, facing: :east}) == %{x: 0, y: 0, facing: :west}
    assert D12.ship_follow_instruction({"R", 270}, %{x: 0, y: 0, facing: :east}) == %{x: 0, y: 0, facing: :north}
    assert D12.ship_follow_instruction({"R", 360}, %{x: 0, y: 0, facing: :east}) == %{x: 0, y: 0, facing: :east}
  end

  test "waypoint_follow_instruction" do
    move_1 = D12.waypoint_follow_instruction({"F", 10}, {%{x: 10, y: 1}, %{x: 0, y: 0, facing: :east}})
    {_wp, ship} = move_1
    assert ship.x == 100
    assert ship.y == 10

    move_2 = D12.waypoint_follow_instruction({"N", 3}, move_1)
    {wp, ship} = move_2
    assert wp.y == 4
    assert wp.x == 10
    assert ship.x == 100 
    assert ship.y == 10 

    move_3 = D12.waypoint_follow_instruction({"F", 7}, move_2)
    {wp, ship} = move_3
    assert ship.x == 170
    assert ship.y == 38
    assert wp.x == 10
    assert wp.y == 4

    move_4 = D12.waypoint_follow_instruction({"R", 90}, move_3)
    {wp, ship} = move_4
    assert wp.x == 4
    assert wp.y == -10
    assert ship.x == 170
    assert ship.y == 38

    move_5 = D12.waypoint_follow_instruction({"F", 11}, move_4)
    {wp, ship} = move_5
    assert ship.x == 214
    assert ship.y == -72
    assert wp.x == 4
    assert wp.y == -10
  end

  test "blah2" do
    input = """
    F10
    N3
    F7
    R90
    F11
    """
    |> String.trim()

    assert D12.caluclate_waypoint_distance(input) == 286
  end
end
