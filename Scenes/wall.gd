class_name Wall
extends Node3D

const Wall_Directions: Dictionary = {
	"NorthWall": Vector3(-1, 0, 0),
	"EastWall": Vector3(0, 0, -1),
	"SouthWall": Vector3(1, 0, 0),
	"WestWall": Vector3(0, 0, 1)
}

@export var max_width: int = 3
@export var max_height: int = 4

@onready var brick_camera_front = $BrickCameraFront
@onready var signal_bus = get_node("/root/SignalBus")
@onready var camera_transition = get_node("/root/CameraTransition")
@onready var brick_scene : PackedScene = load("res://Scenes/brick.tscn")

@onready var bricks : Array[Brick] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus.brick_clicked.connect(_on_brick_clicked)
	
	for h in max_height:
		for w in max_width:
			var brick = brick_scene.instantiate()
			add_child(brick)
			var pos = Vector3(0, (h * 2) + 1, (w * -3.76 + 3.76) - ((h % 2) * 0.5 * 3.76)) # calc the brick world position
			brick.position = pos
			bricks.append(brick)
	
func _on_brick_clicked(brick, wall):
	var wall_vector = Wall_Directions[wall.get_name()]
	var front_cam_position = brick.position - wall_vector
	brick_camera_front.rotation
