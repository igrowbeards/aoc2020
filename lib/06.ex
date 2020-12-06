defmodule DaySix do
  @input_path "input_files/06_input.txt"

  def run_p1(input \\ @input_path) do
    input
    |> File.read!()
    |> count_groups(&count_total_affirmative/1)
  end

  def run_p2(input \\ @input_path) do
    input
    |> File.read!()
    |> count_groups(&count_group_affirmative/1)
  end

  def count_groups(input, count_fun) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(0, fn group, acc -> acc + count_fun.(group) end)
  end

  def count_total_affirmative(input) do
    input
    |> String.graphemes()
    |> Enum.uniq()
    |> Enum.reject(&(&1 == "\n"))
    |> Enum.count()
  end

  def count_group_affirmative(input) do
    group_members_count =
      input
      |> String.split("\n", trim: true)
      |> Enum.count()

    input
    |> String.graphemes()
    |> Enum.reject(&(&1 == "\n"))
    |> Enum.frequencies()
    |> Enum.count(fn {_, count} -> count == group_members_count end)
  end
end
