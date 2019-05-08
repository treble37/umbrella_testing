defmodule ApiWeb.Ping do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  @moduledoc """
  Plug to handle a ping request
  """

  def init(opts) do
    Keyword.get(opts, :paths, [])
  end

  def call(%{request_path: path} = conn, paths) do
    paths
    |> ping?(path)
    |> case do
      true -> pong(conn)
      false -> conn
    end
  end

  defp ping?(ping_paths, request_path), do: Enum.member?(ping_paths, request_path)

  defp pong(conn) do
    conn
    |> put_status(:ok)
    |> json(%{ping: %{message: "APIWeb Ping: acknowledged"}, version: "APIWeb Version 1"})
    |> halt()
  end
end
