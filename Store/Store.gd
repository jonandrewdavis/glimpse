extends Node

# NOTE: IMPORTANT!!!
# Whenever you have an issue with network calls not passing in parameters, 
# CHECK that you are using the .rpc() function to call it. Otherwise, it'll call
# locally and that is the the source of 99% of bugs with this file. AD, 6/12/2023

# e is event / emit, whatever. just short.
signal e
signal scored

# TODO: Enum of reducer actions like `client_join` and `client_leave`, or ... keys
enum VALUES {
	PLAYERS,
	WEAPONS
}

var is_headless_mode = false
var client_join_info = {}

# NOTE: players[id] accesses  is an int
var store = {
	"players" : {},
	"score": 0
}

func _ready():
	multiplayer.peer_connected.connect(func(_id): self.on_player_join.rpc(_id))

@rpc("any_peer", "reliable")
func on_player_join(_id):
	set_state.rpc('client_join', client_join_info)

@rpc("any_peer", "call_local", "reliable")
func set_state(key, value):
	if multiplayer.is_server():
		if key == 'client_join':

			store.players[value.id] = value
		if key == 'client_leave':
			store.players.erase(value)
		else:
			store[key] = value
		set_store.rpc(store)

@rpc("authority", "call_local", "reliable")
func set_store(_store):
	store = _store
	e.emit()
