defmodule Data.Mnesia.Record do
  @moduledoc """
  Defines conventions around modules that turn other data structures into
  records for storage in mnesia. As mnesia is more table like than key-value,
  there are a number of functions defined on each module that create the schema
  used to store data. These functions are:
  - table_name
  - table_fields
  - indexes

  Because mnesia is rooted in Erlang, the basic data type being stored is a
  record that matches the schema defined by the above functions. Elixir provides
  a way to declare and then generate these records via the defrecord(p)
  functions on the Record module, which is also done in this using macro.

  Finally, the behavior defined here describes the contract the rest of the
  system will use to interact with mnesia. The functions are:

  - to_record/1 : turn the struct being stored into a record, along with
  extracting any additional fields needed for searching through data later.

  - to_struct/1 : extract the struct stored in the data field from the
  record
  """

  @type t :: tuple()

  defmacro __using__(opts) do
    legal_opts = [
      :table_name,
      :table_fields,
      :indexes
    ]

    opts
    |> Keyword.keys()
    |> Enum.each(fn key ->
      Enum.member?(legal_opts, key)
      |> case do
        false ->
          pretty_print =
            legal_opts
            |> Enum.map(&":#{&1}")
            |> Enum.join("\n")

          raise "`#{key}` is not a legal option.  Allowed options are \n\n#{pretty_print}\n"

        _ ->
          nil
      end
    end)

    table_name =
      case opts[:table_name] do
        nil -> raise "table_name must be defined"
        name when not is_atom(name) -> raise "table_name must be an atom"
        name -> name
      end

    table_fields =
      case opts[:table_fields] do
        nil ->
          raise "table_fields must be defined"

        fields when not is_list(fields) ->
          raise "table_fields must be an array"

        fields ->
          Keyword.has_key?(fields, :data)
          |> case do
            false -> raise "Table fields must contain :data"
            true -> fields
          end
      end

    quote do
      @behaviour Data.Mnesia.Record
      require Record

      def table_name, do: unquote(table_name)
      def table_fields, do: Keyword.keys(unquote(table_fields))
      def indexes, do: unquote(opts[:indexes] || [])

      Record.defrecord(unquote(table_name), unquote(table_fields))

      @impl true
      def to_struct(record), do: unquote(table_name)(record, :data)
    end
  end

  @callback to_record(map()) :: any()
  @callback to_struct(any()) :: struct()
end
