defmodule ProblemA do
  @moduledoc """
  ProblemA.
  """

  @doc """
  Start and links to process that stops when it receives the message `:stop`.
  """
  def start_link() do
    Task.start_link(fn() ->
      receive do
        :stop ->
          exit(:normal)
      end
    end)
  end
end
