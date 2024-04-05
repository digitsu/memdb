defmodule MemdbTest do
  use ExUnit.Case
  doctest Memdb

  @moduledoc """
  ["SET", <timestamp>, <key>, <field>, <value> ]
  ["GET", <timestamp>, <key>, <field> ]
  ["COMPARE_AND_SET", <timestamp>, <key>, <field>, <expval>, <newval>]
  ["COMPARE_AND_DELETE", <timestamp>, <key>, <field>, <expval>]
  """

  test "test1" do
    queries = [
      ["SET", "10", "emp1", "age", "20"],
      ["SET", "20", "emp2", "age", "30"],
      ["SET", "30", "emp2", "name", "bill"],
      ["GET", "40", "emp1", "age"],
      ["GET", "50", "emp2", "age"],
      ["SET", "60", "emp2", "age", "35"],
      ["GET", "70", "emp2", "age"],
      ["GET", "80", "emp2", "name"]
    ]

    output = [
      "",
      "",
      "",
      "20",
      "30",
      "",
      "35",
      "bill"
    ]

    assert Memdb.solution(queries) == output
  end

  test "test2" do
    queries = [
      ["SET", "10", "emp1", "age", "20"],
      ["SET", "20", "emp2", "age", "30"],
      ["SET", "30", "emp2", "name", "bill"],
      ["GET", "40", "emp1", "age"],
      ["GET", "50", "emp2", "age"],
      ["SET", "60", "emp2", "age", "35"],
      ["GET", "70", "emp2", "age"],
      ["GET", "80", "emp2", "name"],
      ["COMPARE_AND_SET", "90", "emp2", "age", "40", "41"],
      ["COMPARE_AND_SET", "100", "emp2", "age", "35", "41"],
      ["GET", "110", "emp2", "age"]
    ]

    output = [
      "",
      "",
      "",
      "20",
      "30",
      "",
      "35",
      "bill",
      "false",
      "true",
      "41"
    ]

    assert Memdb.solution(queries) == output
  end

  test "test3" do
    queries = [
      ["SET", "10", "emp1", "age", "20"],
      ["SET", "20", "emp2", "age", "30"],
      ["SET", "30", "emp2", "name", "bill"],
      ["GET", "40", "emp1", "age"],
      ["GET", "50", "emp2", "age"],
      ["SET", "60", "emp2", "age", "35"],
      ["GET", "70", "emp2", "age"],
      ["GET", "80", "emp2", "name"],
      ["COMPARE_AND_SET", "90", "emp2", "age", "40", "41"],
      ["COMPARE_AND_SET", "100", "emp2", "age", "35", "41"],
      ["GET", "110", "emp2", "age"],
      ["COMPARE_AND_DELETE", "115", "emp2", "age", "50"],
      ["COMPARE_AND_DELETE", "120", "emp2", "age", "41"],
      ["GET", "130", "emp2", "age"]
    ]

    output = [
      "",
      "",
      "",
      "20",
      "30",
      "",
      "35",
      "bill",
      "false",
      "true",
      "41",
      "false",
      "true",
      ""
    ]

    assert Memdb.solution(queries) == output
  end
end
