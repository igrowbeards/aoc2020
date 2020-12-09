defmodule DayNine do
  @input_path "input_files/09_input.txt"
  @default_preamble 25

  def run_p1(input \\ @input_path) do
    input
    |> File.read!()
    |> find_invalid()
  end

  def run_p2(input \\ @input_path) do
    vulnerability = 15690279

    input
    |> File.read!()
    |> crack(vulnerability)
  end

  def crack(input, vulnerability, digits \\ 2) do
    input = parse_input(input)

    # Drugs are bad M'kay?
    do_crack(input, input, vulnerability, digits)
  end

  # exit case
  def do_crack(input, original, vulnerability, digits) when length(input) < digits do
    do_crack(original, original, vulnerability, digits + 1)
  end

  def do_crack([h | t] = input, original, vulnerability, digits) do
    {current, rest} = Enum.split(input, digits)
    if Enum.sum(current) == vulnerability do
      Enum.max(current) + Enum.min(current)
    else
      do_crack(t, original, vulnerability, digits)
    end
  end

  def find_invalid(input, preamble_length \\ @default_preamble) do
    input
    |> parse_input()
    |> do_find_invalid(preamble_length)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def do_find_invalid([h | t] = input, preamble_length) do
    {preamble, [target | rest]} = Enum.split(input, preamble_length)
    if member_valid?(preamble, target) do
      do_find_invalid(t, preamble_length)
    else
      target
    end
  end

  def member_valid?(preamble, target) do
    {min, max} = find_min_max(preamble)
    valid?(target, preamble, min, max)
  end

  def member_valid?(chunk) do
    [target | preamble] = Enum.reverse(chunk)
    {min, max} = find_min_max(preamble)
    valid?(target, preamble, min, max)
  end

  # fails quick validation
  def valid?(target, _preamble, min, max) when target < min or target > max, do: false

  # passed quick validation
  def valid?(target, preamble, _min, _max) do
    Enum.member?(find_possible_vals(preamble), target)
  end

  def find_possible_vals(list, acc \\ [])

  def find_possible_vals(list, acc) when length(list) == 1, do: List.flatten(acc)

  def find_possible_vals([head | tail], acc) do
    new_acc = [Enum.map(tail, & &1 + head) | acc]
    find_possible_vals(tail, new_acc)
  end

  defp find_min_max(preamble) do
    sorted = Enum.sort(preamble)
    min = Enum.take(sorted, 2) |> Enum.sum()
    max = Enum.reverse(sorted) |> Enum.take(2) |> Enum.sum()
    {min, max}
  end
end
