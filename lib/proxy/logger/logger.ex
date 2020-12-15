defmodule Proxy.Logger do
  alias  Proxy.Logger.Producer

  @doc """
  save events

  - params
  event: - event map containing log data - accumulative up the max batch size
  event: - a events list with max list length of 100 - processed immediately

  ## Examples

      iex> Proxy.Logger.save_event(%{person: "Anthony"})
      :ok
      iex> Proxy.Logger.save_event([%{person: "Anthony"}, %{person: "Peter"}])
  """

  def save_event(event) do
    Producer.add(event)
  end

  @doc """
  process logs
  a callback function that receives log events list.
  process logs callback function is envoked when:
   - batch_size: 100 is reached
   - batch_timeout: 2_000 elapses before batch size of 100 is reached
  """

  def process_logs(log_events) do
    # TODO: save to database
    IO.inspect(log_events, label: "Processing the following Log events\n")
  end
end
