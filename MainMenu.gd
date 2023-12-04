extends Control

const PORT = 8888

func _ready():
	pass

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()	
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	start_game()

func _on_join_pressed():
	var ip = ''
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	start_game()


func start_game():
	hide()
	if multiplayer.is_server():
		change_level.call_deferred(load("res://Levels/World.tscn"))

func change_level(scene: PackedScene):
	var level = get_parent().get_node("Level")
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	
	print(level)
	print(scene)
	level.add_child(scene.instantiate())
