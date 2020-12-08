defmodule DaySevenTest do
  use ExUnit.Case

  test "run_p1" do
  end

  test "run_p2" do
  end



  test "test_input" do
    test_rules =
    """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """

    target_color = "shiny gold"
    assert DaySeven.calculate_possible_containers_count(target_color, test_rules) == 4

    target_color = "light red"
    assert DaySeven.calculate_possible_containers_count(target_color, test_rules) == 0

    target_color = "dark orange"
    assert DaySeven.calculate_possible_containers_count(target_color, test_rules) == 0

    target_color = "bright white"
    assert DaySeven.calculate_possible_containers_count(target_color, test_rules) == 2

    target_color = "muted yellow"
    assert DaySeven.calculate_possible_containers_count(target_color, test_rules) == 2

    target_color = "dark olive"
    assert DaySeven.calculate_possible_containers_count(target_color, test_rules) == 5

    target_color = "vibrant plum"
    assert DaySeven.calculate_possible_containers_count(target_color, test_rules) == 5

    target_color = "dotted black"
    assert DaySeven.calculate_possible_containers_count(target_color, test_rules) == 7

    assert DaySeven.run_p1() == 185
  end

  test "part 2" do
    test_rules = """
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
    """

    assert DaySeven.calculate_children("shiny gold", test_rules) == 126

    test_rules = """
    shiny gold bags contain 2 dark red bags, 1 bing barf bag.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
    bing barf bags contain no other bags.
    """

    assert DaySeven.calculate_children("shiny gold", test_rules) == 127

    assert DaySeven.run_p2() == 89084
  end
end
