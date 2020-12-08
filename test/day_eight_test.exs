defmodule DayEightTest do
  use ExUnit.Case

  # @tag :skip
  test "run_p1" do
    assert DayEight.run_p1() == 1814
  end

  # @tag :skip
  test "run_p2" do
    assert DayEight.run_p2() == 1056
  end

 test "test_p1" do
   test_input = """
   nop +0
   acc +1
   jmp +4
   acc +3
   jmp -3
   acc -99
   acc +1
   jmp -4
   acc +6
   """

   assert DayEight.find_value_before_infinite_loop(test_input) == 5
 end

 test "test_p2" do
   test_input = """
   nop +0
   acc +1
   jmp +4
   acc +3
   jmp -3
   acc -99
   acc +1
   jmp -4
   acc +6
   """

   assert DayEight.fix_the_program(test_input) == 8
 end

  test "update instructions" do
     test_instructions = """
     nop +0
     acc +1
     jmp +4
     """
     |> DayEight.build_instructions_list()

    assert DayEight.update_instructions(test_instructions, 0) == [{"jmp",  0}, {"acc",  1}, {"jmp",  4}]
    assert DayEight.update_instructions(test_instructions, 1) == test_instructions
    assert DayEight.update_instructions(test_instructions, 2) == [{"nop",  0}, {"acc",  1}, {"nop",  4}]
  end
end
