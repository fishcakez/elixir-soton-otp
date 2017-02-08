defmodule ProblemD do
  @moduledoc """
  ProblemD.
  """

  @enforce_keys [:pid, :ref]
  defstruct [:pid, :ref]

  @doc """
  Start a task and await on the result, as `Task.async`.
  """
  def async(fun) do
    {:ok, pid} = Task.start_link(__MODULE__, :init, [self(), fun])
    ref = Process.monitor(pid)
    send(pid, {self(), ref})
    %ProblemD{pid: pid, ref: ref}
  end

  def init(parent, fun) do
    receive do
      {^parent, ref} ->
        send(parent, {ref, fun.()})
    end
  end

  @doc """
  Await the result of a task, as `Task.await`
  """
  def await(%ProblemD{ref: ref} = task, timeout) do
    receive do
      {^ref, result} ->
        Process.demonitor(ref, [:flush])
        result
      {:DOWN, ^ref, _, _, reason} ->
        exit({reason, {__MODULE__, :await, [task, timeout]}})
    after
      timeout ->
        Process.demonitor(ref, [:flush])
        exit({:timeout, {__MODULE__, :await, [task, timeout]}})
    end
  end

  @doc """
  Yield to wait the result of a task, as `Task.yield`.
  """
  def yield(%ProblemD{ref: ref} = task, timeout) do
    receive do
      {^ref, result} ->
        Process.demonitor(ref, [:flush])
        {:ok, result}
      {:DOWN, ^ref, _, _, reason} ->
        {:exit, reason}
    after
      timeout ->
        nil
    end
  end
end
