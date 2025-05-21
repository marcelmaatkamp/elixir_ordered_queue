defmodule OrderedQueue.MessageRouter do
  def route(user_id, message) do
    start_handler_if_needed(user_id)
    OrderedQueue.EntityHandler.send_message(user_id, message)
  end

  defp start_handler_if_needed(user_id) do
    case Registry.lookup(OrderedQueue.Registry, user_id) do
      [] ->
        DynamicSupervisor.start_child(
          OrderedQueue.EntitySupervisor,
          {OrderedQueue.EntityHandler, user_id}
        )

      _ -> :ok
    end
  end
end
