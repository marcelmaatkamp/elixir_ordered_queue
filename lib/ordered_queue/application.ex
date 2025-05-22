defmodule OrderedQueue.Application do
  use Application

  def start(_type, _args) do
    children = [
      OrderedQueueWeb.Endpoint,
      {Registry, keys: :unique, name: OrderedQueue.Registry},
      {OrderedQueue.EntitySupervisor, []},
      {Phoenix.PubSub, name: OrderedQueue.PubSub}
    ]

    opts = [strategy: :one_for_one, name: OrderedQueue.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    OrderedQueueWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
