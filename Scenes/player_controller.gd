class_name PlayerController
extends Node

signal left_just_pressed
signal right_just_pressed
signal back_just_pressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left"): 
		emit_signal("left_just_pressed")
	if Input.is_action_just_pressed("right"): 
		emit_signal("right_just_pressed")
	if Input.is_action_just_pressed("back"): 
		emit_signal("back_just_pressed")
