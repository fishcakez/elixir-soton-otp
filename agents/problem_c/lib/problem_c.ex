defmodule ProblemC do
  @moduledoc """
  ProblemC.
  """

  @doc """
  Start task.
  """
  def start_link() do
    Task.start_link(__MODULE__, :loop, [])
  end

  @doc """
  Call task.
  """
  def call(task, request, timeout) do
    ref = Process.monitor(task)
    Process.send(task, {__MODULE__, {self(), ref}, request}, [:noconnect])
    receive do
      {^ref, resp} ->
        Process.demonitor(ref, [:flush])
        resp
      {:DOWN, ^ref, _, pid, :noconnect} ->
        exit({{:nodedown, node(pid)},
          {__MODULE__, :call, [task, request, timeout]}})
      {:DOWN, ^ref, _, _, reason} ->
        exit({reason, {__MODULE__, :call, [task, request, timeout]}})
    after
      timeout ->
        Process.demonitor(ref, [:flush])
        exit({:timeout, {__MODULE__, :call, [task, request, timeout]}})
    end
  end

  @doc """
  Reply to call
  """
  def reply({pid, ref}, response) do
    send(pid, {ref, response})
    :ok
  end

  @doc false
  def loop() do
    receive do
      {__MODULE__, from, :ping} ->
        __MODULE__.reply(from, :pong)
        loop()
      {__MODULE__, _, :ignore} ->
        loop()
      {__MODULE__, _, :stop} ->
        exit(:stop)
    end
  end
end
