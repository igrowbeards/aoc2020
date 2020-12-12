defmodule DayTen do
  @input_path "input_files/10_input.txt"

  def run_p1(input \\ @input_path) do
    input
    |> File.read!()
    |> calculate_joltage_differences()
  end

  def run_p2(input \\ @input_path) do
    input
    |> File.read!()
    |> calculate_possible_combinations()
  end

  def calculate_joltage_differences(input) do
    input
    |> parse_input()
    |> calculate_joltage_differences(0, [])
  end

  def calculate_joltage_differences([], _current, acc) do
    [3 | acc]
    |> Enum.frequencies()
    |> (fn %{1 => a, 3 => b} -> a * b end).()
  end

  def calculate_joltage_differences([next_adapter | rest], current, acc) do
    calculate_joltage_differences(rest, next_adapter, [next_adapter - current | acc])
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end

  def calculate_possible_combinations(input) do
    input
    |> parse_input()
    |> List.insert_at(0, 0)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
    |> Enum.chunk_by(& &1 == 1)
    |> Enum.reject(fn l -> l == [1] || Enum.all?(l, & &1 == 3) end)
    |> Enum.map(&length/1)
    |> Enum.map(fn a ->
      case a do
        2 -> 2
        3 -> 4
        4 -> 7
      end
    end)
    |> Enum.reduce(1, & &1 * &2 )
  end

end
