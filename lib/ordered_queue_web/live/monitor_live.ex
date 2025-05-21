defmodule OrderedQueueWeb.MonitorLive do
  use OrderedQueueWeb, :live_view

  @impl true
  def mount(_, _, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(OrderedQueue.PubSub, "updates")
    {:ok, assign(socket, entities: %{})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl font-bold mb-4">Live Entity Monitor</h1>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <%= for {id, messages} <- @entities do %>
          <div class="border rounded-xl p-4 shadow-md bg-white">
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
