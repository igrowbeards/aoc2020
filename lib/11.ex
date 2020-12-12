defmodule DayEleven do
  @input_path "input_files/11_input.txt"

  def run_p1(input \\ @input_path) do
    input
    |> File.read!()
    |> parse_input()
    |> mutate_seating_until_dupe()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(& String.split(&1, "", trim: true))
  end

  def mutate_seating_until_dupe(seating_list, seen \\ []) do
    mutated = mutate_seating(seating_list)
    if Enum.member?(seen, mutated) do
      mutated
      |> List.flatten()
      |> Enum.count(& &1 == "#")
    else
      mutate_seating_until_dupe(mutated, [mutated | seen])
    end
  end

  def mutate_seating(seating_list) do
    seating_list
    |> Enum.with_index()
    |> Enum.map(fn {seats_in_row, row_number} -> 
      seats_in_row
      |> Enum.with_index()
      |> Enum.map(fn {seat_status, seat_col} ->
        surrounding = get_surrounding_seats(seating_list, row_number, seat_col)
        mutate_seat(seat_status, surrounding)
      end)
    end)
  end

  def get_surrounding_seats(seats, seat_row, seat_col) do
    row_before = get_col(seats, seat_row - 1)

    nw = get_seat(row_before, seat_col - 1)
    n = get_seat(row_before, seat_col)
    ne = get_seat(row_before, seat_col + 1)

    row_of = get_col(seats, seat_row)
    w = get_seat(row_of, seat_col - 1)
    e = get_seat(row_of, seat_col + 1)

    row_after = get_col(seats, seat_row + 1)

    sw = get_seat(row_after, seat_col - 1)
    s = get_seat(row_after, seat_col)
    se = get_seat(row_after, seat_col + 1)

    [nw, n, ne, w, e, sw, s, se]
  end

  def get_col([h | _rest] = seat_rows, index) when index >= 0 do
    default = Enum.map(0..length(h), fn _ -> nil end)
    Enum.at(seat_rows, index, default)
  end

  def get_col([h | _], _index) do
    Enum.map(0..length(h), fn _ -> nil end)
  end

  def get_seat(seats, index) when index >= 0 do
    Enum.at(seats, index, nil)
  end

  def get_seat(_seats, _index), do: nil

  def parse_row(input) do
    input
    |> String.split("", trim: true)
  end

  def seating_list_to_string(seating_list) do
    seating_list
    |> Enum.map(& Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  def mutate_seat("L", surrounding_seats) do
    if Enum.all?(surrounding_seats, & Enum.member?(["L", ".", nil], &1)) do
      "#"
    else
      "L"
    end
  end

  def mutate_seat("#", surrounding_seats) do
    if Enum.count(surrounding_seats, & &1 == "#") >= 4 do
      "L"
    else
      "#"
    end
  end

  def mutate_seat(other, _surrounding_seats), do: other
end
