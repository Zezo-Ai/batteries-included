defmodule EventCenter.Postgres do
  use GenServer

  alias Phoenix.PubSub

  @pubsub EventCenter.Usage.PubSub

  @impl true
  def init(_) do
    {:ok, nil}
  end

  def broadcast(action, object)
      when action in [:delete_cluster, :create_cluster, :update_cluster] do
    PubSub.broadcast(@pubsub, topic(), {action, object})
  end

  def subscribe do
    PubSub.subscribe(@pubsub, topic())
  end

  def topic do
    Atom.to_string(__MODULE__)
  end
end
