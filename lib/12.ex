defmodule DayTwelve do
  @input_path "input_files/12_input.txt"

  def run_p1() do
    File.read!(@input_path)
    |> caluclate_distance()
  end

  def run_p2() do
    File.read!(@input_path)
    |> caluclate_waypoint_distance()
  end

  def caluclate_distance(instructions) do
    instructions
    |> parse_instructions()
    |> ship_follow_instructions()
    |> (fn %{x: x, y: y} -> abs(x) + abs(y) end).()
  end

  def caluclate_waypoint_distance(instructions) do
    instructions
    |> parse_instructions()
    |> waypoint_follow_instructions()
    |> (fn {_, ship} -> (abs(ship.x) + abs(ship.y)) end).()
  end

  def parse_instructions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&split_intruction/1)
  end

  def split_intruction(<<command::bytes-size(1)>> <> value) do
    {command, String.to_integer(value)}
  end

  def ship_follow_instructions(instructions_list) do
    Enum.reduce(instructions_list, %{x: 0, y: 0, facing: :east}, &ship_follow_instruction/2)
  end

  def waypoint_follow_instructions(instructions_list) do
    Enum.reduce(instructions_list, {%{x: 10, y: 1}, %{x: 0, y: 0, facing: :east}}, &waypoint_follow_instruction/2)
  end

  def waypoint_follow_instruction_debug(a, b) do
    IO.inspect(a, label: "instruction")
    waypoint_follow_instruction(a, b)
    |> IO.inspect()
  end

  def waypoint_follow_instruction({"F", value}, {waypoint, ship}) do
    x_distance = waypoint.x * value
    y_distance = waypoint.y * value
    {waypoint, %{ship | x: ship.x + x_distance, y: ship.y + y_distance}}
  end

  def waypoint_follow_instruction({"N", value}, {waypoint, ship}) do
    {%{waypoint | y: waypoint.y + value}, ship}
  end

  def waypoint_follow_instruction({"S", value}, {waypoint, ship}) do
    {%{waypoint | y: waypoint.y - value}, ship}
  end

  def waypoint_follow_instruction({"E", value}, {waypoint, ship}) do
    {%{waypoint | x: waypoint.x + value}, ship}
  end

  def waypoint_follow_instruction({"W", value}, {waypoint, ship}) do
    {%{waypoint | x: waypoint.x - value}, ship}
  end

  def waypoint_follow_instruction({dir, value}, {waypoint, ship}) when dir in ["L", "R"] do
    updated_waypoint = case floor(value / 90) do
      1 -> rotate_waypoint(dir, waypoint)
      num_turns -> Enum.reduce(1..num_turns, waypoint, fn _, wp -> rotate_waypoint(dir, wp) end)
    end
    {updated_waypoint, ship}
  end

  defp rotate_waypoint("R", %{x: x, y: y}) do
    %{x: y, y: x * -1}
  end

  defp rotate_waypoint("L", %{x: x, y: y}) do
    %{x: -y, y: x}
  end

  def ship_follow_instruction({"N", value}, %{y: y} = pos), do: %{pos | y: y + value}
  def ship_follow_instruction({"S", value}, %{y: y} = pos), do: %{pos | y: y - value}
  def ship_follow_instruction({"E", value}, %{x: x} = pos), do: %{pos | x: x + value}
  def ship_follow_instruction({"W", value}, %{x: x} = pos), do: %{pos | x: x - value}
  def ship_follow_instruction({"F", value}, %{facing: facing} = pos) do
    case facing do
      :north -> ship_follow_instruction({"N", value}, pos)
      :east -> ship_follow_instruction({"E", value}, pos)
      :south -> ship_follow_instruction({"S", value}, pos)
      :west -> ship_follow_instruction({"W", value}, pos)
    end
  end

  def ship_follow_instruction({dir, value}, %{facing: facing} = pos) when dir in ["L", "R"] do
    %{pos | facing: turn(dir, value, facing)}
  end

  def turn(dir, degrees, current_dir) do
    dirs = case dir do
      "R" -> [:north, :east, :south, :west]
      "L" -> [:north, :east, :south, :west] |> Enum.reverse()
    end

    target_dir = Enum.find_index(dirs, & &1 == current_dir) + floor(degrees / 90)

    cond do
      target_dir < length(dirs) - 1 -> Enum.at(dirs, target_dir)
      true -> Enum.at(dirs, rem(target_dir, length(dirs)))
    end
  end
end
