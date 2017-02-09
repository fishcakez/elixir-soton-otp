defmodule ProblemB do
  @moduledoc """
  ProblemB.
  """

  @doc """
  Stop a GenServer. Expects GenServer to stop with reason `reason` on receiving
  call `{:stop, reason}`. GenServer should reply with message `:ok`.
  """
  def stop(gen_server) do
    ref = Process.monitor(gen_server)
    GenServer.call(gen_server, {:stop, :normal}, :infinity)
    receive do
      {:DOWN, ^ref, _, _, :normal} -> :ok
      {:DOWN, ^ref, _, _, reason} ->
        exit({reason, {__MODULE__, :stop, [gen_server]}})
    end
  end
end
