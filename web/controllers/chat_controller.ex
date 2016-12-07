# Defines what controller the chat uses.

defmodule ClassChat.ChatController do
	use ClassChat.Web, :controller

	def index(conn, _params) do
		render conn, "lobby.html"
	end

end
