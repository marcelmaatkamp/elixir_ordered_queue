defmodule OrderedQueueWeb.MessageController do
  use OrderedQueueWeb, :controller

  def create(conn, %{"user_id" => user_id, "message" => message}) do
    OrderedQueue.MessageRouter.route(user_id, message)
    json(conn, %{status: "queued", user_id: user_id, message: message})
  end
end
