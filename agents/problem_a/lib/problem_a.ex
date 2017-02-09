defmodule ProblemA do
  @moduledoc """
  ProblemA.
  """

  @doc """
  Start Agent with map as state.
  """
  def start_link(map) when is_map(map) do
    Agent.start_link(fn() -> map end)
  end

  @doc """
  Fetch a value from the agent.
  """
  def fetch!(agent, key) do
    fun = fn(map) ->
      try do
        Map.fetch!(map, key)
      rescue
        err in [KeyError] ->
          {:error, err}
      else
        val ->
          {:ok, val}
      end
    end
    case Agent.get(agent, fun) do
      {:ok, val}    -> val
      {:error, err} -> raise err
    end
  end
end
