extends Node

# Server is authorativie LIST of EVERYTHING. and we do nothing but link up the "text".
# properties in the Syncronizer!

@export var score = 0
@export var peer_list = []

func _ready():
	Store.e.connect(refresh)
	pass
	
func refresh():
	$Control/Label.text = str(Store.store.score)
	var completePlayers = ""
	for id in Store.store.players: 
		var single = ""
		for k in Store.store.players[id]:
			single += str(Store.store.players[id][k]) + ', '

		completePlayers += 'player: ' + single + '\n '
	
	$Control/Players.text = completePlayers
	pass
