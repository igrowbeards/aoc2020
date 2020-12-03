defmodule DayThree do
  @default_slope %{x: 3, y: 1}
  @input_file_path "./03_input.txt"

  def run_p1() do
    @input_file_path
    |> File.read!()
    |> calculate_collisions()
  end

  def run_p2() do
    slopes = [%{x: 1, y: 1}, %{x: 3, y: 1}, %{x: 5, y: 1}, %{x: 7, y: 1}, %{x: 1, y: 2}]

    File.read!(@input_file_path)
    |> calculate_collisions(slopes)
    |> Enum.reduce(fn results, acc -> acc * results end)
  end

  defp calculate_collisions(input, slope \\ @default_slope)

  defp calculate_collisions(input, slopes) when is_list(slopes) do
    Enum.map(slopes, fn slope -> calculate_collisions(input, slope) end)
  end

  defp calculate_collisions(input, slope) do
    input
    |> parse_map()
    |> Enum.take_every(slope.y)
    |> traverse_map(slope)
  end

  defp traverse_map([head | _tail] = input, slope) do
    input
    |> Enum.reduce(%{x: 0, tree_count: 0, map_width: String.length(head), slope: slope}, &count_trees/2)
    |> Map.get(:tree_count)
  end

  defp count_trees(row, acc) do
    new_tree_count =
      if tree_here?(row, acc.map_width, acc.x), do: acc.tree_count + 1, else: acc.tree_count

    %{acc | x: acc.x + acc.slope.x, tree_count: new_tree_count}
  end

  defp tree_here?(input, m_width, x) when x <= m_width - 1, do: String.at(input, x) == "#"

  defp tree_here?(input, m_width, x), do: String.at(input, rem(x, m_width)) == "#"

  defp parse_map(input), do: String.split(input, "\n", trim: true)
end

DayThree.run_p2() |> IO.inspect()
DayThree.run_p1() |> IO.inspect()
