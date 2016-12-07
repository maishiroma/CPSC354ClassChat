# Defines what a room channel has and what functions it does.

defmodule ClassChat.RoomChannel do
	use ClassChat.Web, :channel
	alias ClassChat.Presence

	def join("rooms:lobby", message, socket) do
		Process.flag(:trap_exit, true)
		send(self, {:after_join, message})
		{:ok, socket}
	end

	def join("rooms:" <> _something_else, _msg, _socket) do
		{:error, %{reason: "Can't go in here!"}}
	end

	# This event occurs when a user joins the room.
	def handle_info({:after_join, msg}, socket) do
		# This part updated where the user has been online and puts it in the tracker.
		Presence.track(socket, socket.assigns.user, %{
			online_at: :os.system_time(:milli_seconds)
		})
		push(socket, "presence_state", Presence.list(socket))

		# This part puts an announcement into the message chat area.
		broadcast! socket, "user:entered", %{user: msg["user"]}
		push socket, "join", %{status: "Connected to room!"}
		{:noreply, socket}
	end

	def terminate(_reason, _socket) do
		:ok
	end

	# This handles new messages.
	def handle_in("new:msg", msg, socket) do

		# Checks if the user has changed their name
		for {key, value} <- Presence.list(socket) do
  		if(key == socket.assigns.user) do
				Map.delete(Presence.list(socket), socket)
  		end
		end

		# Updates the presence list with the updated name if it changed.
		if(Enum.member?(Presence.list(socket), socket) == false) do
			push(socket, "presence_state", Presence.list(socket))
		end

		# Once it does the presence stuff, it then sends the message out.
		broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
		{:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
	end

end
