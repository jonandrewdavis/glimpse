extends Control

const PORT = 8888

func _ready():
	pass

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()	
	peer.create_server(PORT)
	multiplayer.allow_object_decoding  = true
	multiplayer.multiplayer_peer = peer
	Store.client_join_info = {
		"nickname": $Nickname.text,
		"color": $ColorPickerButton.color,
		"ip": 'N/A',
		"network_id": multiplayer.get_unique_id(),
	}
	start_game()

func _on_join_pressed():
	var ip = ''
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.allow_object_decoding  = true
	multiplayer.multiplayer_peer = peer
	Store.client_join_info = {
		"nickname": $Nickname.text,
		"color": $ColorPickerButton.color,
		"ip": 'N/A',
		"id": multiplayer.get_unique_id(),
	}
	start_game()

func start_game():
	# If we're a client, we just hide. But, if we're a server, we load everything.
	hide()
	# TODO: await, and if we're disconnected, show a couldn't connect, and error.
	if multiplayer.is_server():
		change_level.call_deferred(load("res://Levels/World.tscn"))

func change_level(scene: PackedScene):
	var level = get_parent().get_node("Level")
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()

	level.add_child(scene.instantiate())
