defmodule Letterex.RandomList do
  def start_link items, options \\ [] do
    Agent.start_link fn -> do_shuffle {[], items} end, options
  end

  def stop name do
    Agent.stop name
  end
  
  def shuffle name do
    Agent.update(name, &(do_shuffle &1))
  end 

  defp do_shuffle {remaining, used} do
    :random.seed(:os.timestamp)
    items =  List.flatten [remaining | used]
      |>  Enum.shuffle
    {items, []}
  end
  
  def get name do
    Agent.get_and_update name, &(do_get &1)
  end
  
  # Shuffle once more than half the items have been used
  defp do_get({items, used}) when length(items) < length(used) do
    do_get do_shuffle({items, used})  
  end

  defp do_get {[item | rest], used} do
    {item, {rest, [item | used]}}
  end    
end