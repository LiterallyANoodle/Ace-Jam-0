class_name PlayerController
extends Node

enum Mode { MAIN_MENU, WALL_VIEW, BRICK_VIEW }

const Wall_Directions: Dictionary = {
	"NorthWall": Vector3(-1, 0, 0),
	"EastWall": Vector3(0, 0, -1),
	"SouthWall": Vector3(1, 0, 0),
	"WestWall": Vector3(0, 0, 1)
}

signal left_just_pressed
signal right_just_pressed
signal back_just_pressed

@onready var current_mode: Mode = Mode.WALL_VIEW

@onready var signal_bus = get_node("/root/SignalBus")

func _ready():
	signal_bus.brick_clicked.connect(_on_brick_clicked)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_mode == Mode.WALL_VIEW:
		if Input.is_action_just_pressed("left"): 
			emit_signal("left_just_pressed")
		if Input.is_action_just_pressed("right"): 
			emit_signal("right_just_pressed")
	if Input.is_action_just_pressed("back"): 
		emit_signal("back_just_pressed")
		
func _on_brick_clicked(brick, wall):
	print("clicked brick!")
	
