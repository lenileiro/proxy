defmodule Proxy.Logger.Producer do

  use GenStage

  def start_link(_args) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:producer, []}
  end

  def handle_info(_, state) do
    reset()
    {:noreply, [], state}
  end

  # public endpoint for adding log events
  def add(events), do: GenServer.cast(__MODULE__, {:add, events})
  defp get(), do: GenServer.call(__MODULE__, {:get})

  defp reset(), do: GenServer.call(__MODULE__, {:reset})

  def handle_call({:reset},_from, _state) do
    {:reply, [], [], []}
  end

  def handle_call({:get}, _from, state) do
    {:reply, state, state, state}
  end

  # just push events to consumers on added event
  def handle_cast({:add, events}, _state) when is_list(events) do
    {:noreply, events, events}
  end

  def handle_cast({:add, events} , state) do
    {:noreply, [events | state], [events | state]}
  end

  def handle_demand(demand, state) when demand > length(state) do
    send(self(), :reset_state)
    handle_demand(demand, state ++ get())
  end

  def handle_demand(demand, state) do
    {to_dispatch, remaining} = Enum.split(state, demand)
    {:noreply, to_dispatch, remaining}
  end

end
