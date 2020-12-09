defmodule DayNineTest do
  use ExUnit.Case

  @tag :skip
  test "run_p1" do
    assert DayNine.run_p1() == 15690279
  end

  @tag :skip
  test "run_p2" do
    assert DayNine.run_p2() == 2174232
  end

  test "blah" do
    test_data = """
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """
    assert true

    test_preamble = 5
    assert DayNine.find_invalid(test_data, test_preamble) == 127
  end

  test "member_valid?" do
    blah = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25]
    assert DayNine.member_valid?(blah ++ [26])

    blah = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25]
    refute DayNine.member_valid?(blah ++ [65])

    blah = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 45]
    refute DayNine.member_valid?(blah ++ [65])

    assert = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 45]
    assert DayNine.member_valid?(blah ++ [66])

    assert = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23, 24, 25, 45]
    assert DayNine.member_valid?(blah ++ [64])

    [95, 102, 117, 150, 182, 127]
    |> DayNine.member_valid?() 
    |> refute 

    [65, 95, 102, 117, 150, 182]
    |> DayNine.member_valid?() 
    |> assert 

    [65, 95, 102, 117, 150, 182]
    |> DayNine.member_valid?()
    |> assert 

    [25, 47, 40, 62, 55, 65]
    |> DayNine.member_valid?()
    |> assert 
  end

  test "p2" do
    input = """
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """

    assert DayNine.crack(input, 127) == 62
  end

  # test "find_possible_vals" do
  #   chunk = [1, 2, 3]
  #   assert Enum.sort(DayNine.find_possible_vals(chunk)) == [3, 4, 5]
  # end
end
