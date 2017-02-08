defmodule ProblemB do
  @moduledoc """
  ProblemB.
  """

  @doc """
  Start process that stops after a delay when it receives the message `:stop`.
  """
  def start() do
    Task.start(fn() ->
      receive do
        :stop ->
          :timer.sleep(1000)
          exit(:normal)
      end
    end)
  end

  @doc """
  Stop the process.
  """
  def stop(pid) do
    ref = Process.monitor(pid)
    send(pid, :stop)
    receive do
      {:DOWN, ^ref, _, _, _} ->
        :ok
    end
  end
end
