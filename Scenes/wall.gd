class_name Wall
extends Node3D

@onready var grid_map : GridMap = $Bricks
@onready var bricks_positions : Array[Vector3i] = grid_map.get_used_cells()

@onready var bricks_scene : PackedScene = load("res://Scenes/brick.tscn")
@onready var bricks : Array[Brick] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for pos in bricks_positions:
		# convert grid position into world position
		var local_pos = grid_map.map_to_local(pos)
		print(local_pos)
		# place in meshes
		var brick = bricks_scene.instantiate()
		brick.position = local_pos
		bricks.append(brick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
