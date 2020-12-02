defmodule DayTwo do
  def run_p1, do: count_valid_passwords(&password_valid_new?/1) |> IO.inspect()
  def run_p2, do: count_valid_passwords(&password_valid_old?/1) |> IO.inspect()

  def count_valid_passwords(validator) do
    File.read!("./02_1_input.txt")
    |> String.split("\n", trim: true)
    |> Enum.count(validator)
  end

  def password_valid_old?(pass) do
    {min, max, target, password} = parse_line(pass)

    occurences = password
    |> String.graphemes()
    |> Enum.count(fn char -> char == target end)

    occurences >= min && occurences <= max
  end

  def password_valid_new?(pass) do
    {pos1, pos2, target, password} = parse_line(pass)
    p1_match? = String.at(password, pos1 - 1) == target
    p2_match? = String.at(password, pos2 - 1) == target
    (p1_match? && !p2_match?) || (!p1_match? && p2_match?)
  end

  defp parse_line(str) do
    [int_a_str, int_b_str, target_char, "", pw] = String.split(str, ["-", ":", " "])
    {int_a, _} = Integer.parse(int_a_str)
    {int_b, _} = Integer.parse(int_b_str)
    {int_a, int_b, target_char, pw}
  end
end

DayTwo.run_p1()
DayTwo.run_p2()
