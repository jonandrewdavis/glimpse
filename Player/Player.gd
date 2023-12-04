extends CharacterBody2D
class_name Player

# Stats (TODO: Move to a resource system)
const CONST_MAX_HP = 100;
const CONST_MAX_STAMNIA = 30;

@export var max_hp: int = CONST_MAX_HP
@export var hp: int = CONST_MAX_HP

@export var max_stamina: int = CONST_MAX_STAMNIA
@export var stamina: int = CONST_MAX_STAMNIA

# Physics
const CONST_STARTING_SPEED = 130; # increase for top speed
const CONST_ACCELERATION = 220 # decrease to cause more startup time
const CONST_FRICTION = 280

@export var friction: int = 250 # decrease to cause sliding
@export var acceleration = CONST_ACCELERATION
@export var max_speed = CONST_STARTING_SPEED

# Input
var mouse_direction: Vector2
var mov_direction: Vector2

# 
var PLAYER_START: Vector2 = Vector2(0, 0)

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	# This a
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	set_physics_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	if not is_multiplayer_authority():
		return
		
	var newCamera = Camera2D.new()
	newCamera.ignore_rotation = true
	newCamera.limit_smoothed = true
	add_child(newCamera)

	var rng = RandomNumberGenerator.new()
	var rndX = int(rng.randi_range(int(PLAYER_START.x) - 50, int(PLAYER_START.x) + 50))
	var rndY = int(rng.randi_range(int(PLAYER_START.y) - 50, int(PLAYER_START.y) + 50))
	position = Vector2(rndX, rndY)
	
func _process(_delta):
	mouse_direction = (get_global_mouse_position() - global_position).normalized()
	get_input()
	if mouse_direction.x > 0 and $Sample.flip_h:
		$Sample.flip_h = false
	elif mouse_direction.x < 0 and not $Sample.flip_h:
		$Sample.flip_h = true


func _physics_process(delta):
	if mov_direction != Vector2.ZERO:
		velocity = velocity.move_toward(mov_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

func get_input():
	mov_direction = Vector2.ZERO
	mov_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	mov_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	mov_direction = mov_direction.normalized()
	
	if Input.is_action_just_released("f"):
		create_object.rpc()

@rpc("call_local", "reliable")
func create_object():
	if multiplayer.is_server():
		var fire = load("res://Projectiles/Fireball.tscn")
		var fun = fire.instantiate()
		fun.position = global_position
		print('Creat in:', get_multiplayer_authority())
		get_parent().get_parent().get_node('AllObjects').add_child(fun, true)
		


# if is_on_wall() and FSM.current_state.name != 'PlayerMove':
	# velocity = velocity.move_toward(mov_direction * max_speed * 0.9, (acceleration * 1.05) * delta)
