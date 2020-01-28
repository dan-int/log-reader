defmodule LogReaderWeb.PageController do
  use LogReaderWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
