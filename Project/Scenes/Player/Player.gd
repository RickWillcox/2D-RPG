extends KinematicBody2D

onready var animation_tree = get_node("AnimationTree")
onready var animation_mode = animation_tree.get("parameters/playback")
onready var animation_player = get_node("AnimationPlayer")
onready var joystick = get_node("../GUI/Joystick")

var max_speed = 200
var speed = 0
var acceleration = 400
var destination = Vector2()
var movement = Vector2()
var moving = false
var player_state
var using_joystick = false
var joystick_vector = Vector2()

func _ready():
	pass

func _physics_process(delta):
	if joystick and joystick.is_working:
		joystick_vector = joystick.output
		using_joystick = true
		moving = true
	MovementLoop(delta)
	using_joystick = false
	
func MovementLoop(delta):
	if !moving:
		speed = 0
	else:
		speed += acceleration * delta
		if speed > max_speed:
			speed = max_speed
		if using_joystick:
			movement = position.direction_to(position + (joystick_vector * 1000)) * speed
			movement = move_and_slide(movement)
			animation_tree.set("parameters/Walk/blend_position", joystick_vector)
			animation_tree.set("parameters/Idle/blend_position", joystick_vector)	
			animation_mode.travel("Walk")
		else:
			moving = false	
			animation_mode.travel("Idle")
