class_name Castle
extends Node3D

@onready var timer = $Timer
@onready var walls: Array[Wall] = [ $NorthWall, $SouthWall, $EastWall, $WestWall ]

# decrement a random brick's health
func _on_timer_timeout():
	# find random brick
	var wall_index = randi() % 4
	var brick_index = randi() % 12
	var brick = null
	for _i in 20: # try to erode a brick with health 20 times
		brick = walls[wall_index].get_brick(brick_index)
		if brick.brick_health > 0:
			# decrement its health
			brick.decrement_health()
			break
