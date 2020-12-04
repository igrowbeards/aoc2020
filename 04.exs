defmodule DayFour do
  @hacked_fields [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]

  def run_p1(input), do: parse_and_count_valid(input)

  def run_p2(input), do: parse_and_count_valid(input, true)

  def parse_and_count_valid(input, validate_values? \\ false) do
    input
    |> extract_passport_data()
    |> Enum.map(&passport_valid?(&1, validate_values?))
    |> Enum.count(& &1)
  end

  defp passport_valid?(passport_data, validate_values?) do
    pw_keys = Keyword.keys(passport_data)
    all_present = Enum.all?(@hacked_fields, fn field -> Enum.member?(pw_keys, field) end)

    if validate_values? do
      all_present &&
        Enum.all?(Keyword.take(passport_data, @hacked_fields), &try_validate_element/1)
    else
      all_present
    end
  end

  defp extract_passport_data(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_passport/1)
  end

  defp parse_passport(passport_string) do
    passport_string
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(&parse_passport_values/1)
  end

  defp parse_passport_values(<<key::bytes-size(3)>> <> ":" <> value) do
    key = String.to_atom(key)
    {key, try_parse_val(key, value)}
  end

  defp try_parse_val(input, key) do
    parse_val(input, key)
  rescue
    _ -> :parse_error
  end

  defp try_validate_element(element) do
    element_valid?(element)
  rescue
    _ -> false
  end

  defp parse_val(:parse_error, _), do: false
  defp parse_val(key, val) when key in [:byr, :iyr, :eyr, :cid], do: String.to_integer(val)
  defp parse_val(_, val), do: val

  defp element_valid?({:byr, val}), do: val >= 1920 && val <= 2002
  defp element_valid?({:iyr, val}), do: val >= 2010 && val <= 2020
  defp element_valid?({:eyr, val}), do: val >= 2020 && val <= 2030

  defp element_valid?({:ecl, val}),
    do: Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], val)

  defp element_valid?({:pid, val}) do
    parsed = String.to_integer(val)
    String.length(val) == 9 && parsed < 999_999_999 && parsed > 0
  end

  defp element_valid?({:hgt, val}) when is_binary(val) do
    case Integer.parse(val) do
      {n, "cm"} -> n >= 150 && n <= 193
      {n, "in"} -> n >= 59 && n <= 76
      _ -> false
    end
  end

  defp element_valid?({:hcl, "#" <> <<color::bytes-size(6)>>}),
    do: String.match?(color, ~r/[0-9,a-f]{6}/)

  defp element_valid?({:hcl, _}), do: false

  defp element_valid?(_), do: false
end

File.read!("./04_input.txt")
|> DayFour.run_p1()
|> IO.inspect()

File.read!("./04_input.txt")
|> DayFour.run_p2()
|> IO.inspect()
