defmodule OrderedQueueWeb.MonitorLive do
  use OrderedQueueWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    IO.puts("📬 Subscribing to updates...")
    # Ensure you're subscribed before fetching initial state to avoid race conditions
    # where an update might be missed if it happens between fetching and subscribing.
    # However, for initial load, fetching then subscribing is also common.
    # Given PubSub is for "updates", fetching current state first is logical.
    Phoenix.PubSub.subscribe(OrderedQueue.PubSub, "updates")

    # Fetch the current state of entities.
    # Replace `OrderedQueue.State.get_all()` with your actual function to retrieve entities.
    initial_entities = OrderedQueue.State.get_all() # Example placeholder
    {:ok, assign(socket, entities: initial_entities || %{})}
  end

  @impl true
  def handle_info({:update, %{user_id: id, messages: messages}}, socket) do
    IO.inspect({:received_pubsub, id, messages}, label: "MonitorLive.handle_info update")
    updated = Map.put(socket.assigns.entities, id, messages)
    {:noreply, assign(socket, entities: updated)}
  end

  @impl true
  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl font-bold mb-4">Live Entity Monitor</h1>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <pre><%= inspect(@entities) %></pre>
        <%= for {id, messages} <- @entities do %>
          <div class="border rounded-xl p-4 shadow-md bg-red">
            <h2 class="font-semibold text-lg mb-2"><%= id %></h2>
            <ul class="list-disc pl-5 text-sm text-gray-700">
              <%= for msg <- messages do %>
                <li><%= msg %></li>
              <% end %>
            </ul>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
