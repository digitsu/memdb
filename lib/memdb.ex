defmodule Memdb do
  @moduledoc """
  Documentation for `Memdb`.
  """

  defmodule Database do
    use Agent

    def start_link(initial_val \\ %{}) do
      Agent.start_link(fn -> initial_val end, name: __MODULE__)
    end

    def reset() do
      Agent.update(__MODULE__, fn _state -> %{} end)
    end

    def value do
      Agent.get(__MODULE__, & &1)
    end

    def set(_ts, key, newmap) do
      target_nested_map = Map.get(Database.value(), key, %{})
      merged_nested_map = Map.merge(target_nested_map, newmap)
      updated_nested_map = Map.put(Database.value(), key, merged_nested_map)
      Agent.update(__MODULE__, fn _state -> updated_nested_map end)
      ""
    end

    def delete(_ts, key, field) do
      target_nested_map = Map.get(Database.value(), key, %{})
      new_nested_map = Map.delete(target_nested_map, field)
      updated_nested_map = Map.put(Database.value(), key, new_nested_map)
      Agent.update(__MODULE__, fn _state -> updated_nested_map end)
      ""
    end

    def get(_ts, key, field) do
      keymap = Map.get(Database.value(), key, %{})
      Map.get(keymap, field, "")
    end

    def comp_set(ts, key, field, expval, newval) do
      target_nested_map = Map.get(Database.value(), key, %{})
      if Map.get(target_nested_map, field, "") == expval do
        Database.set(ts, key, %{field => newval})
        "true"
      else
        "false"
      end
    end

    def comp_del(ts, key, field, expval) do
      target_nested_map = Map.get(Database.value(), key, %{} )
      if Map.get(target_nested_map, field, "") == expval do
        Database.delete(ts, key, field)
        "true"
      else
        "false"
      end
    end
  end

  def solution(queries) do
    case Database.start_link() do
      {:ok, _pid} -> "created"
      {:error, {:already_started, _pid}} -> Database.reset()
    end

    process = fn query ->
      case query do
        ["GET", ts, key, field] ->
          Database.get(ts, key, field)

        ["SET", ts, key, field, value] ->
          Database.set(ts, key, %{field => value})

        ["COMPARE_AND_SET", ts, key, field, expval, newval] ->
          Database.comp_set(ts, key, field, expval, newval)

        ["COMPARE_AND_DELETE", ts, key, field, expval] ->
          Database.comp_del(ts, key, field, expval)

        _ ->
          "unsupported op"
      end
    end

    output = Enum.map(queries, fn query -> process.(query) end)
    output
  end
end
