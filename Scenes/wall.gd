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
@onready var castle_camera = get_node("../CameraPath/CameraPathFollower/Camera3D")
@onready var signal_bus = get_node("/root/SignalBus")
@onready var state = get_node("/root/State")
@onready var camera_transition = get_node("/root/CameraTransition")
@onready var brick_scene : PackedScene = load("res://Scenes/brick.tscn")

@onready var bricks : Array[Brick] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus.brick_clicked.connect(_on_brick_clicked)
	signal_bus.back_pressed.connect(_on_back_pressed)
	
	for h in max_height:
		for w in max_width:
			var brick = brick_scene.instantiate()
			add_child(brick)
			var pos = Vector3(0, (h * 2) + 1, (w * -3.76 + 3.76) - ((h % 2) * 0.5 * 3.76)) # calc the brick world position
			brick.position = pos
			bricks.append(brick)
	
func _on_brick_clicked(brick, wall):
	if state.get_state() == state.Mode.WALL_VIEW:
		if wall == self:
			print("brick clicked!")
			state.set_state(state.Mode.BRICK_VIEW)
			var front_cam_position = brick.position - Vector3(-1, 0, 0) * 3
			print(front_cam_position)
			brick_camera_front.position = front_cam_position
			CameraTransition.transition_camera3d(castle_camera, brick_camera_front, 0.1)
		
func _on_back_pressed():
	if state.get_state() == state.Mode.BRICK_VIEW:
		print("go back!")
		state.set_state(state.Mode.WALL_VIEW)
		
func get_brick(index: int) -> Brick:
	return bricks[index]
