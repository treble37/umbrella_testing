defmodule Data.Mnesia.Init do
  @moduledoc """
  Functions for initializing and setting up Mnesia.
  """

  @type table_properties :: %{:table_name => atom(), :table_fields => keyword()}
  @type table_properties_list :: list(table_properties)

  @mnesia_modules [
    Data.Mnesia.User
  ]

  @doc """
  create mnesia schema
  """
  def init_schema() do
    case schema_created_anywhere?() do
      true ->
        {:ok, :already_created}

      false ->
        Enum.each(Node.list([:visible]), fn n -> Node.spawn_link(n, &:mnesia.stop/0) end)
        :mnesia.stop()
        :mnesia.init_schema(nodes())
        :mnesia.start()
        Enum.map(Node.list([:visible]), fn n -> Node.spawn_link(n, &:mnesia.start/0) end)
    end
  end

  @doc """
  """
  def create_table(module, table_type \\ :set) do
    case table_created?(module.table_name()) do
      true ->
        guarantee_indexes(module)
        {:ok, :already_created}

      false ->
        opts = [
          {:attributes, module.table_fields},
          {:type, table_type},
          {:index, module.indexes()},
          {storage_type(), nodes()}
        ]

        :mnesia.create_table(module.table_name(), opts)
    end
  end

  def add_node(name) do
    :mnesia.change_table_copy_type(:schema, name, storage_type())
    :mnesia.add_table_copy(:schema, name, storage_type())

    @mnesia_modules
    |> Enum.each(&:mnesia.add_table_copy(&1, name, storage_type()))
  end

  def nodes(), do: [node() | Node.list([:visible])]

  @doc """
  Return true if the mnesia schema exists
  """
  @spec schema_created?() :: true | false
  def schema_created?() do
    :mnesia.table_info(:schema, storage_type()) != []
  end

  @doc """
  Return true if the mnesia schema exists somewhere in the cluster
  """
  @spec schema_created_anywhere?() :: true | false
  def schema_created_anywhere?() do
    {answers, _} = :rpc.multicall(nodes(), __MODULE__, :schema_created?, [])
    Enum.any?(answers, fn x -> x end)
  end

  @doc """
  Return true if the mnesia table exists
  """
  @spec table_created?(atom()) :: true | false
  def table_created?(table_name) do
    Enum.member?(:mnesia.system_info(:tables), table_name)
  end

  @doc """
  Helper function to ensure the mnesia schema and associated tables are created
  on startup
  """
  @spec bootstrap_mnesia() :: no_return
  def bootstrap_mnesia() do
    init_schema()

    @mnesia_modules
    |> Enum.each(&create_table/1)
  end

  defp storage_type do
    Application.get_env(:data, :mnesia)[:storage_type]
  end

  defp guarantee_indexes(module) do
    :mnesia.wait_for_tables([module.table_name()], 10_000)
    |> case do
      :ok ->
        module.indexes()
        |> Enum.each(&Data.MnesiaHelper.ensure_index(module.table_name(), &1))

      result ->
        raise "Ensure indexes failed #{inspect(result)}"
    end
  end
end
