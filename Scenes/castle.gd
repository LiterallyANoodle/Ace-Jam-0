class_name Castle
extends Node3D

@onready var timer = $Timer
@onready var walls: Array[Wall] = [ $NorthWall, $SouthWall, $EastWall, $WestWall ]

func _on_timer_timeout():
	seed(Time.get_ticks_msec())
	
