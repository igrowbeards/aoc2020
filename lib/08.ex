defmodule DayEight do
  @input_path "input_files/08_input.txt"

  def run_p1(input \\ @input_path) do
    input
    |> File.read!()
    |> find_value_before_infinite_loop()
  end

  def run_p2(input \\ @input_path) do
    input
    |> File.read!()
    |> fix_the_program()
  end

  def find_value_before_infinite_loop(input) do
    {:error, last_val} = input
    |> build_instructions_list()
    |> execute_instructions()

    last_val
  end

  def fix_the_program(instructions) do
    instructions = instructions
    |> build_instructions_list()

    target_indexes = instructions
    |> Enum.with_index()
    |> Enum.filter(fn {{op, _}, _index} -> Enum.member?(["jmp", "acc"], op) end)
    |> Enum.map(fn {_, i} -> i end)

    fix_the_program(instructions, instructions, target_indexes)
  end

  def fix_the_program(instructions, original_instructions, [index | future_indexes]) do
    case execute_instructions(instructions) do
      {:error, _} ->
        nil
        updated = update_instructions(original_instructions, index) 
        fix_the_program(updated, original_instructions, future_indexes)
      {:finished, acc} -> acc
    end
  end

  def update_instructions(instructions, index) do
    instructions
    |> Enum.at(index)
    |> switch_operation()
    |> (& List.replace_at(instructions, index, &1)).()
  end

  def switch_operation({"jmp", i}), do: {"nop", i}
  def switch_operation({"nop", i}), do: {"jmp", i}
  def switch_operation(other), do: other

  def execute_instructions(instructions, current_index \\ 0, seen \\ [], acc \\ 0)

  def execute_instructions(instructions, current_index, seen, acc) do
    cond do
      current_index == length(instructions) ->
        {:finished, acc}
      Enum.member?(seen, current_index) ->
        {:error,  acc}
      true ->
        {op, target} = Enum.at(instructions, current_index)
        case op do
          "nop" -> 
            execute_instructions(instructions, current_index + 1, [current_index | seen], acc)
          "acc" -> 
            execute_instructions(instructions, current_index + 1, [current_index | seen], acc + target)
          "jmp" -> 
            target_index = current_index + target
            execute_instructions(instructions, target_index, [current_index | seen], acc)
        end
    end
  end

  def build_instructions_list(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction(instruction) do
    instruction
    |> String.split(" ")
    |> List.to_tuple()
    |> (fn {op, tar_str} -> {op, String.to_integer(tar_str)} end).()
  end
end
