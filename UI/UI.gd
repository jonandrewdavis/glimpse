extends Node

@export var score = 0
@export var peer_list = []

@onready var menu_ref = $CanvasLayer/SettingsMenu
@onready var players_label = $CanvasLayer/SettingsMenu/Panel/VBoxContainer/Players
@onready var score_label = $CanvasLayer/SettingsMenu/Panel/VBoxContainer/Score

func _ready():
	menu_ref.hide()
	Store.e.connect(refresh)
	pass

func refresh():
	score_label.text = str(Store.store.score)
	var completePlayers = ""
	for id in Store.store.players: 
		var single = ""
		for k in Store.store.players[id]:
			single += str(Store.store.players[id][k]) + ', '
		completePlayers += 'player: ' + single + '\n'
	players_label.text = completePlayers
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("esc") or Input.is_action_just_pressed("tab"):
		menu_ref.visible = !menu_ref.visible
