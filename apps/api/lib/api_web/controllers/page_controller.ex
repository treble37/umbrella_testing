defmodule ApiWeb.PageController do
  use ApiWeb, :controller

  def index(conn, _params) do
    json(conn, %{"page_controller" => "ApiWeb.PageController#index/1"})
  end
end
