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
	
	if not multiplayer.is_server():
		return
		
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(delete_player)
	
	for id in multiplayer.get_peers():
		add_player(id)
		
	if not OS.has_feature('dedicated_server'):
		add_player(1)
		
func add_player(id: int):
	var character_scene = preload("res://Player/Player.tscn")
	var character =  character_scene.instantiate()
	character.name = str(id)
	print('player add')
	$AllPlayers.add_child(character, true)	

func delete_player(id):
	if not $AllPlayers.has_node(str(id)):
		return
	$AllPlayers.get_node(str(id)).queue_free()
	
func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(add_player)
