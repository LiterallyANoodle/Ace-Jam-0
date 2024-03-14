class_name PlayerController
extends Node

signal left_just_pressed
signal right_just_pressed

@onready var signal_bus = get_node("/root/SignalBus")
@onready var state = get_node("/root/State")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state.failed != true:
		# controls
		if state.get_state() == state.Mode.WALL_VIEW:
			if Input.is_action_just_pressed("left"): 
				emit_signal("left_just_pressed")
			if Input.is_action_just_pressed("right"): 
				emit_signal("right_just_pressed")
		if state.get_state() == state.Mode.BRICK_VIEW:
			if Input.is_action_just_pressed("back"): 
				signal_bus.back_pressed.emit()
				
	# exit game
	if Input.is_action_just_pressed("Esc"):
		get_tree().quit()
