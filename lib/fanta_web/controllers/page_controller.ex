defmodule FantaWeb.PageController do
  use FantaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
