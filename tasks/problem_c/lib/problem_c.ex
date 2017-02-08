defmodule ProblemC do
  @moduledoc """
  ProblemC.
  """

  @doc """
  Run an anonymous function in a separate process.

  Returns `{:ok, result} if the function runs successfully, otherwise
  `{:error, exception}` if an exception is raised.
  """
  def run(fun) do
    fun = fn() ->
      try do
        fun.()
      rescue
        ex ->
          {:error, ex}
      else
        res ->
          {:ok, res}
      end
    end
    task = Task.async(fun)
    Task.await(task, :infinity)
  end
end
