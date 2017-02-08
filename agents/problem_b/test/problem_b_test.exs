defmodule ProblemBTest do
  use ExUnit.Case
  doctest ProblemB

  use GenServer

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:stop, reason}, from, state) do
    GenServer.reply(from, :ok)
    {:stop, reason, state}
  end

  def terminate(_, _) do
    :timer.sleep(1000)
  end

  test "stop a GenServer" do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil)
    assert ProblemB.stop(pid) == :ok
    refute Process.alive?(pid)
  end

  test "restart new GenServer immediately" do
    {:ok, pid1} = GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
    assert ProblemB.stop(pid1) == :ok
    {:ok, pid2} = GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
    refute Process.alive?(pid1)
    assert Process.alive?(pid2)
  end
end
