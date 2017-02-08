defmodule ProblemCTest do
  use ExUnit.Case
  doctest ProblemC

  test "ping replies with pong" do
    {:ok, pid} = ProblemC.start_link()
    assert ProblemC.call(pid, :ping, 5000) == :pong
    assert ProblemC.call(pid, :ping, 5000) == :pong
  end

  test "successfull call flushes monitor" do
    {:ok, pid} = ProblemC.start_link()
    assert ProblemC.call(pid, :ping, 5000) == :pong
    # check monitor to pid does not exist)
    assert {_, monitored} = Process.info(pid, :monitored_by)
    refute self() in monitored
  end

  test "ignored call times out and flushes monitor" do
    {:ok, pid} = ProblemC.start_link()
    assert catch_exit(ProblemC.call(pid, :ignore, 123)) ==
      {:timeout, {ProblemC, :call, [pid, :ignore, 123]}}

    # check monitor to pid does not exist)
    assert {_, monitored} = Process.info(pid, :monitored_by)
    refute self() in monitored
  end

  @tag :capture_log
  test "process stops while call in progress" do
    Process.flag(:trap_exit, true)
    {:ok, pid} = ProblemC.start_link()

    assert catch_exit(ProblemC.call(pid, :stop, 123)) ==
      {:stop, {ProblemC, :call, [pid, :stop, 123]}}

    refute Process.alive?(pid)
  end
end
