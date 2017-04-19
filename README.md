# Overview
- This is a chat application, built using Elixir (back end) and Javascript (front end). I made this for my final project for CPSC 354 (Programming Languages), using the programming lanaguage, Elixir, I chose to study over the semester. The service that is hosting this chat program is Heroku. 

[Try this out here!](https://secure-fjord-62788.herokuapp.com)

# Features
- A "Who's Online" widget that allows you to see how many users are online as well as when they logged in.
- Each user can choose their own username.
- When you change your username, the "Who's Online" widget dynamically updates for everyone in the room to reflect your new name.
- There's a limit to how long your username is as well as how long of a message you can send.
- The chat room is also notified when a new user has entered the room.
- If the user doesn't choose a name, the chat program will assign a name to them.
- There's also a limit to how many people can be on the chat room (10 people).
- If a user is inactive for a certain amount of time, they will be removed from the chat automatically.

# Bugs
- When you change your username, all new users that enter the room will have that same name displayed in the "Who's Online" window.
- The app isn't entirely optimized for mobile phones, so when looking at it from a mobile device, the screen may be a bit crunched.
