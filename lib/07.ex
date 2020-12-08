defmodule DaySeven do
  @input_path "input_files/07_input.txt"

  def run_p1(input \\ @input_path) do
    input = File.read!(input)
    calculate_possible_containers_count("shiny gold", input)
  end

  def run_p2(input \\ @input_path) do
    input = File.read!(input)
    calculate_children("shiny gold", input)
  end

  def get_possible_containers(bag_color, rules) when is_binary(bag_color) do
    get_possible_containers([bag_color], rules, [])
  end

  def get_possible_containers([], _rules, acc), do: acc

  def get_possible_containers(bag_colors, rules, acc) do
    bag_colors
    |> Enum.map(&Map.get(rules, &1))
    |> Enum.reject(&(&1 == nil))
    |> List.flatten()
    |> (&get_possible_containers(&1, rules, [&1 | acc])).()
    |> List.flatten()
  end

  def calculate_possible_containers_count(bag_color, rules) do
    rules_map = build_ancestry_map(rules)

    get_possible_containers(bag_color, rules_map)
    |> Enum.uniq()
    |> Enum.count()
  end

  def calculate_children(bag_color, rules) do
    rules_map = build_dependent_map(rules)
    find_required_children([{bag_color, 1}], rules_map, 1, 0) - 1
  end

  defp build_ancestry_map(input) do
    input = String.split(input, "\n", trim: true)

    Enum.reduce(input, %{}, fn line, acc ->
      line
      |> split_container_from_contents()
      |> parse_contents_and_add_to_map(acc)
    end)
  end

  defp parse_contents_and_add_to_map(s, acc) do
    [h | rest] = s

    rest
    |> Enum.map(&extract_color/1)
    |> Enum.reduce(acc, fn child, acc ->
      Map.get_and_update(acc, child, fn current ->
        case current do
          nil -> {nil, [h]}
          current -> {current, [h | current]}
        end
      end)
      |> elem(1)
    end)
  end

  defp split_container_from_contents(line) do
    line
    |> String.replace([".", "bags", "bag"], "")
    |> String.split([" contain ", ", "], trim: true)
    |> Enum.map(&String.trim/1)
  end

  defp extract_color(phrase) do
    phrase
    |> String.split(" ")
    |> Enum.slice(1..2)
    |> Enum.join(" ")
  end


  defp find_required_children([], _rules_map, _parent_count, acc), do: acc

  defp find_required_children([{bag_color, per_parent} | rest], rules_map, parent_count, acc) do
    bags_this_level = parent_count * per_parent

    new_acc =
      Map.get(rules_map, bag_color)
      |> find_required_children(rules_map, bags_this_level, bags_this_level + acc)

    find_required_children(rest, rules_map, parent_count, new_acc)
  end

  defp build_dependent_map(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &parse_string/2)
  end

  defp parse_string(rule_string, acc) do
    [h | rest] = split_and_parse_rule(rule_string)

    rest
    |> Enum.map(&split_and_parse_children/1)
    |> List.flatten()
    |> (&Map.put(acc, h, &1)).()
  end

  defp split_and_parse_rule(rule) do
    rule
    |> String.replace(["bags", "bag", "."], "")
    |> String.replace("  ", " ")
    |> String.split("contain")
    |> Enum.map(&String.trim/1)
  end

  defp split_and_parse_children(children_string) do
    children_string
    |> String.split(" , ")
    |> Enum.map(&extract_number_color/1)
    |> Enum.reject(&(&1 == nil))
  end

  defp extract_number_color(num_color_string) do
    case num_color_string do
      <<count::bytes-size(1)>> <> " " <> color -> {color, String.to_integer(count)}
      _ -> nil
    end
  end
end
