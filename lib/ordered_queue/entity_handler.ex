defmodule OrderedQueue.EntityHandler do
  use GenServer

  def start_link(user_id) do
    GenServer.start_link(__MODULE__, user_id, name: via(user_id))
  end

  defp via(id), do: {:via, Registry, {OrderedQueue.Registry, id}}

  def send_message(user_id, message) do
    GenServer.cast(via(user_id), {:process, message})
  end

  def init(user_id) do
    {:ok, %{user_id: user_id}}
  end

  def handle_cast({:process, message}, state) do
    IO.puts("[#{state.user_id}] Processing message: #{inspect(message)}")
    Process.sleep(500)  # simulate some work
    {:noreply, state}
  end
end
