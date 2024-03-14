extends Node

@onready var in_transition: bool = false
@onready var camera3d: Camera3D = $Camera3D

func transition_camera3d(from: Camera3D, to: Camera3D, duration: float = 0.25) -> void:
	if in_transition: return
	
	# copy the first camera 
	camera3d.fov = from.fov
	camera3d.cull_mask = from.cull_mask
	camera3d.global_transform = from.global_transform
	
	# change current 
	camera3d.current = true 
	in_transition = true
	
	# tween to second camera 
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(camera3d, "global_transform", to.global_transform, duration)
	tween.parallel().tween_property(camera3d, "fov", to.fov, duration)
	await tween.finished
	
	# swap to new camera 
	to.current = true
	in_transition = false

func copy_camera3d(from: Camera3D, to: Camera3D) -> void:
	# copy the first camera 
	to.fov = from.fov
	to.cull_mask = from.cull_mask
	to.global_transform = from.global_transform
