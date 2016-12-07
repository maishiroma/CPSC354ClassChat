defmodule ClassChat.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "rooms:*", ClassChat.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket,
    timeout: 45_000
  transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.

  #def connect(_params, socket) do
  #  {:ok, socket}
  #end

  def connect(%{"user" => user}, socket) do
    {:ok, assign(socket, :user, user)}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:

  # Assigns nil to a user if they don't have an ID.
  def id(socket) do
    if(socket.id == nil) do
      nil
    else
      "users_socket:#{socket.assigns.user_id}"
    end
  end
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #   ClassChat.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  # def id(_socket), do: nil

end
