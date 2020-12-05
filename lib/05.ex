defmodule DayFive do
  @rows for i <- 0..127, do: "#{i}"
  @columns for i <- 0..7, do: "#{i}"

  @input_path "input_files/05_input.txt"

  def run_p1() do
    File.read!(@input_path)
    |> String.split("\n", trim: true)
    |> Enum.map(&calculate_seat_id/1)
    |> Enum.max()
  end

  def run_p2() do
    passes = File.read!(@input_path)
    |> String.split("\n", trim: true)
    |> Enum.map(&calculate_seat_id/1)
    |> Enum.sort()

    min = Enum.min(passes)
    max = Enum.max(passes)

    [result] = Enum.reduce(min..max, [], fn seat_id, acc ->
      if Enum.member?(passes, seat_id) do
        acc
      else
        [seat_id | acc]
      end
    end)

    result
  end

  def calculate_seat_id(<<row::bytes-size(7)>> <> column), do: calculate_row(row) * 8 + calculate_column(column)

  def calculate_row(row_id), do: reduce_pass_part(row_id, @rows)

  def calculate_column(col_id), do: reduce_pass_part(col_id, @columns)

  defp reduce_pass_part(<<head::bytes-size(1)>> <> rest, seats) do
    case head do
      a when a in ["L", "F"] -> 
        results = Enum.slice(seats, 0, half_length(seats))
        reduce_pass_part(rest, results)
      a when a in ["B", "R"] -> 
        half_length = half_length(seats)
        results = Enum.slice(seats, half_length, half_length)
        reduce_pass_part(rest, results)
    end
  end

  defp reduce_pass_part("", [val]) do
    String.to_integer(val)
  end

  defp half_length(seats) do
    seats
    |> Enum.count()
    |> Kernel./(2)
    |> round()
  end
end
