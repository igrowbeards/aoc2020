defmodule DayEleven do
  @input_path "input_files/11_input.txt"

  def run_p1(input \\ @input_path) do
    input
    |> File.read!()
    |> parse_input()
    |> mutate_seating_until_dupe()
  end

  def run_p2(input \\ @input_path) do
    input
    |> File.read!()
    |> parse_input()
    |> mutate_seating_until_dupe_picky()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, &parse_row/2)
  end

  def parse_row({row_string, row_index}, acc) do
    row_string
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {seat_status, seat_index}, acc -> Map.put(acc, {row_index, seat_index}, seat_status) end)
  end

  def mutate_seating_until_dupe_picky(seating_list, seen \\ []) do
    mutated = mutate_seating_picky(seating_list)
    if Enum.member?(seen, mutated) do
      Enum.count(mutated, fn {_, status} -> status == "#" end)
    else
      mutate_seating_until_dupe_picky(mutated, [mutated | seen])
    end
  end

  def mutate_seating_until_dupe(seating_list, seen \\ []) do
    mutated = mutate_seating(seating_list)
    if Enum.member?(seen, mutated) do
      Enum.count(mutated, fn {_, status} -> status == "#" end)
    else
      mutate_seating_until_dupe(mutated, [mutated | seen])
    end
  end

  def mutate_seating(seating_list) do
    seating_list
    |> Enum.map(fn {index, seat_status} -> {index, mutate_seat(seat_status, get_surrounding_seats(seating_list, index))} end)
    |> Map.new()
  end

  def mutate_seating_picky(seating_list) do
    seating_list
    |> Enum.map(fn {index, seat_status} -> {index, mutate_seat(seat_status, get_nearest_seats(seating_list, index), true)} end)
    |> Map.new()
  end

  def get_surrounding_seats(seats, {seat_row, seat_col}) do
    [
      {seat_row - 1, seat_col - 1},
      {seat_row - 1, seat_col},
      {seat_row - 1, seat_col + 1},
      {seat_row, seat_col - 1},
      {seat_row, seat_col + 1},
      {seat_row + 1, seat_col - 1},
      {seat_row + 1, seat_col},
      {seat_row + 1, seat_col + 1},
    ]
    |> Enum.map(& Map.get(seats, &1, nil))
  end

  def get_nearest_seats(seats, seat_id) do
    [
      get_nearest(seats, seat_id, :nw),
      get_nearest(seats, seat_id, :n),
      get_nearest(seats, seat_id, :ne),
      get_nearest(seats, seat_id, :w),
      get_nearest(seats, seat_id, :e),
      get_nearest(seats, seat_id, :sw),
      get_nearest(seats, seat_id, :s),
      get_nearest(seats, seat_id, :se)
    ]
  end

  def offset_for(seat, dir, offset \\ 1)

  def offset_for({r, c}, :nw, offset), do: {r - offset, c - offset}
  def offset_for({r, c}, :n, offset), do: {r - offset, c}
  def offset_for({r, c}, :ne, offset), do: {r - offset, c + offset}
  def offset_for({r, c}, :w, offset), do: {r, c - offset}
  def offset_for({r, c}, :e, offset), do: {r, c + offset}
  def offset_for({r, c}, :sw, offset), do: {r + offset, c - offset}
  def offset_for({r, c}, :s, offset), do: {r + offset, c}
  def offset_for({r, c}, :se, offset), do: {r + offset, c + offset}

  def get_nearest(seats, seat_id, dir, offset \\ 1) do
    case Map.get(seats, offset_for(seat_id, dir, offset)) do
      "." -> get_nearest(seats, seat_id, dir, offset + 1)
      other -> other
    end
  end

  def seating_list_to_string(seating_list, _room_width) do
    room_width = Enum.count(seating_list, fn {{row_num, _}, _} -> row_num == 0 end)

    seating_list
    |> Enum.sort()
    |> Enum.map(fn {_, status} -> status end)
    |> Enum.chunk_every(room_width)
    |> Enum.map(& Enum.join(&1, ""))
    |> Enum.join("\n")
  end

  def mutate_seat(status, surrounding_seats, picky \\ false)

  def mutate_seat("L", surrounding_seats, _picky) do
    if Enum.all?(surrounding_seats, & Enum.member?(["L", ".", nil], &1)) do
      "#"
    else
      "L"
    end
  end

  def mutate_seat("#", surrounding_seats, false) do
    if Enum.count(surrounding_seats, & &1 == "#") >= 4 do
      "L"
    else
      "#"
    end
  end

  def mutate_seat("#", surrounding_seats, true) do
    if Enum.count(surrounding_seats, & &1 == "#") >= 5 do
      "L"
    else
      "#"
    end
  end

  def mutate_seat(other, _surrounding_seats, _picky), do: other
end
