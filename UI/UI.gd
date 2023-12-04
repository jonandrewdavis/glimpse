extends Node

# Server is authorativie LIST of EVERYTHING. and we do nothing but link up the "text".
# properties in the Syncronizer!

@export var peer_list = []

func _ready():
	if not multiplayer.is_server():
		return 
	multiplayer.peer_connected.connect(update_label)
# TODO: Signal based? RPC based? What.

# Would be nice if it was a Syncronizer.

func update_label(_id):
	print('updating', multiplayer.get_peers())
	var complete = "something here: "
	var peers = multiplayer.get_peers()
	for p in peers:
		peer_list.append(str(p))
		complete += "IP: " + str(p) + "\n "
	$Control/Label.text = complete	
	
	# part 2
	var new_string = ""
	for player_name in peer_list:
		new_string += "player: " + player_name + " \n, "
	$Control/Players.text = new_string


func update_label_local(_id):
		# part 2
	print('im client')
	var new_string = ""
	for player_name in peer_list:
		new_string += "player: " + player_name + " \n, "
	$Control/Players.text = new_string
