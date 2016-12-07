// Allows for users to enter messages, send them, and display them in the chat.
import {Presence} from "phoenix"

class Gossip {

	static init(socket){
		var $status = $("#status")
		var $messages = $("#messages")
		var $input = $("#message-input")
		var $username = $("#username")
		var prevUsername = null

		socket.onOpen( ev => console.log("OPEN", ev) )
		socket.onError( ev => console.log("ERROR", ev) )
		socket.onClose( e => console.log("CLOSE", e) )

		var chan = socket.channel("rooms:lobby", {})

		chan.join()
			.receive("ignore", () => console.log("Authentication Error!"))
			.receive("ok", () => console.log("You're ok!"))
			.receive("timeout", () => console.log("Connection interruption..."))

		chan.onError(e => console.log("Uh, something went wrong...", e))
		chan.onClose(e => console.log("The channel was closed.", e))

		// If the user entered a valid message, send the message off.
		$input.off("keypress").on("keypress", e => {
			if (e.keyCode == 13 && $input.val() != "" && $username.val().length < 16) {
				chan.push("new:msg", {user: $username.val(), body: $input.val()}, 10000)
				$input.val("")

				// If the username has changed, the presence will then change as well.
				if($username.val() != prevUsername)
				{
						this.presence(socket, $username.val())
						prevUsername = $username.val()
				}
			}
		})

		// Appends the new message to the chat
		chan.on("new:msg", msg => {
			$messages.append(this.messageTemplate(msg, socket.id))
			scrollTo(0, document.body.scrollHeight)
		})

		// Announces that a new user has entered the room.
		chan.on("user:entered", msg => {
			var username = this.sanitize(socket.id)
			$messages.append(`<br/><i>${username} has entered the room! Please set your username before chatting!</i>`)
			prevUsername = ""
		})
	}

	// Formats string so that it can be displayed in HTML
	static sanitize(html){
		return $("<div/>").text(html).html()
	}

	// How the messages are formatted so that they can be displayed on the screen.
	static messageTemplate(msg, initalUsername){
		let username = this.sanitize(msg.user || initalUsername)
		if(username != initalUsername)
			username = username + " (" + initalUsername + ")"

		let body = this.sanitize(msg.body)
		return(`<p><a href='#'>[${username}]</a>&nbsp; ${body}</p>`)
	}

	// This part handles the users presence in our application.
	static presence(socket, username)
	{
		let presences = {}
		let formatTimestamp = (timestamp) => {
			let date = new Date(timestamp)
			return date.toLocaleTimeString()
		}

		let listBy = (user, {metas: metas}) => {
			return {
				user: username,
				onlineAt: formatTimestamp(metas[0].online_at)
			}
		}

		// This then updates the rooms so that the user is on there.
		let userList = document.getElementById("UserList")
		let render = (presences) => {
			userList.innerHTML = Presence.list(presences, listBy)
				.map(presence => `
					<li>
						${presence.user}
						<br>
						<small>online since ${presence.onlineAt}</small>
					</li>
				`)
				.join("")
		}

		// Updates which channel has the user
		let room = socket.channel("rooms:lobby")
		room.on("presence_state", state => {
			presences = Presence.syncState(presences, state)
			render(presences)
		})
		room.on("presence_diff", diff => {
			presences = Presence.syncDiff(presences, diff)
			render(presences)
		})

	}
}

export default Gossip
