defmodule DayTwo do
  def count_valid_passwords do
    File.stream!("./02_1_input.txt")
    |> Enum.count(&password_valid_new?/1)
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

DayTwo.count_valid_passwords()
|> IO.inspect()
