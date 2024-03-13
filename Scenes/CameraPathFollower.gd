class_name CameraPathFollower
extends PathFollow3D

@onready var next_position: float = 0.0

@onready var signal_bus = get_node("/root/SignalBus")
@onready var ring_camera = $Camera3D

func _ready():
	signal_bus.back_pressed.connect(_back_just_pressed)

func _left_just_pressed():
	print("left signal received")
	self.next_position = self.next_position + 0.25
	var tween = create_tween()
	tween.tween_property(self, "progress_ratio", self.next_position, 0.15)
	await tween.finished
	print(self.next_position)
	self.next_position = fposmod(self.next_position, 1.0)
	self.progress_ratio = fposmod(self.progress_ratio, 1.0)
	

func _right_just_pressed():
	print("right signal received")
	self.next_position = self.next_position - 0.25
	var tween = create_tween()
	tween.tween_property(self, "progress_ratio", self.next_position, 0.15)
	await tween.finished
	print(self.next_position)
	self.next_position = fposmod(self.next_position, 1.0)
	self.progress_ratio = fposmod(self.progress_ratio, 1.0)
	
func _back_just_pressed():
	var from_cam = get_viewport().get_camera_3d()
	CameraTransition.transition_camera3d(from_cam, ring_camera, 0.1)
