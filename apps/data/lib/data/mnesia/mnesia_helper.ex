defmodule Data.MnesiaHelper do
  @moduledoc """
  Helper functions to streamline Mnesia access.
  """

  @doc """
  Clear an mnesia table
  """
  def clear_table(table) do
    :mnesia.transaction(fn -> :mnesia.clear_table(table) end)
  end

  @doc """
  Creates an index for the given table and field
  """
  @spec guarantee_index(atom(), atom()) :: :ok
  def guarantee_index(table, field) do
    :mnesia.add_table_index(table, field)
    |> case do
      {:aborted, {:already_exists, _table, _index}} -> :ok
      {:atomic, :ok} -> :ok
      result -> raise "Could not create index #{field} on #{table}; error #{inspect(result)}"
    end
  end
end
