extends Node2D
class_name World

# "glimpse" is an attempt to create a re-usable multiplayer template for Godot 4.2
# The following things should work:
# - Hosting, with player character and is_server, UPNP optional
# - Joining
# - Clients recieve updates on other joiners
# - Clients can produce a projectile
# - Scoreboard updates on "kill"

func _ready():
	# Welcome players
	# Server code that runs, because the host is already here:
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(add_player_in_server)
		multiplayer.peer_disconnected.connect(delete_player_in_server)
		
		for id in multiplayer.get_peers():
			add_player_in_server(id)
			
		if not OS.has_feature('dedicated_server'):
			add_player_in_server(1)
		
func add_player_in_server(id: int):
	var character_scene = preload("res://Player/Player.tscn")
	var character =  character_scene.instantiate()
	character.name = str(id)
	add_child(character, true)	

func delete_player_in_server(id):
	var to_delete = get_node(str(id))
	if to_delete.has_group('players'):
		get_node(str(id)).queue_free()
	
func _exit_tree():
	if multiplayer.is_server():
		multiplayer.peer_connected.disconnect(add_player_in_server)
		multiplayer.peer_disconnected.disconnect(add_player_in_server)
