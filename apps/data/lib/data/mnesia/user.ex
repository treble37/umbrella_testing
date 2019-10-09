defmodule Data.Mnesia.User do
  @moduledoc """
  A module to assist with storing Data.User data in Mnesia and converting
  it into a format suitable for Elixir records.
  """
  use Data.Mnesia.Record,
    table_name: :user,
    table_fields: [
      id: nil,
      data: %{}
    ]

  @doc """
  convert an Ecto User struct to mnesia user record
  """
  @impl true
  @spec to_record(Data.User.t()) :: Data.Mnesia.Record.t()
  def to_record(%{id: id} = data) do
    region(
      id: id,
      data: data
    )
  end
end
