defmodule ClassChat.PageController do
  use ClassChat.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
