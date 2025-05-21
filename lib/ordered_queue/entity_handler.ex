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
    {:ok, %{user_id: user_id, messages: []}}
  end

  def handle_cast({:process, message}, state) do
    Process.sleep(500)
    new_state = %{state | messages: [message | Enum.take(state.messages, 4)]}
    notify_ui(state.user_id, new_state.messages)
    {:noreply, new_state}
  end

  defp notify_ui(user_id, messages) do
    Phoenix.PubSub.broadcast(
      OrderedQueue.PubSub,
      "updates",
      {:update, %{user_id: user_id, messages: messages}}
    )
  end

end
