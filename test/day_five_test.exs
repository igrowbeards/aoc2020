defmodule DayFiveTest do
  use ExUnit.Case

  test 'parse_row' do 
    assert DayFive.calculate_row("FBFBBFF") == 44
  end

  test 'parse_column' do 
    assert DayFive.calculate_column("RLR") == 5
  end

  test "calculate_seat_id"do
    assert DayFive.calculate_seat_id("BFFFBBFRRR") == 567
    assert DayFive.calculate_seat_id("FFFBBBFRRR") == 119
    assert DayFive.calculate_seat_id("BBFFBBFRLL") == 820
  end

  test "run_p1" do
    assert DayFive.run_p1() == 894
  end
end
