class_name Wall
extends Node3D

@onready var grid_map : GridMap = $Bricks
@onready var bricks_positions : Array[Vector3i] = grid_map.get_used_cells()

# Called when the node enters the scene tree for the first time.
func _ready():
	print(bricks_positions)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
