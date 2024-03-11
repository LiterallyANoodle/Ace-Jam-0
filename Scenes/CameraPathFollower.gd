class_name CameraPathFollower
extends PathFollow3D

@onready var next_position: float = 0.0

func _left_just_pressed():
	print("left signal received")
	self.next_position = self.next_position + 0.25
	var tween = create_tween()
	tween.tween_property(self, "progress_ratio", self.next_position, 0.25)
	await tween.finished
	print(self.next_position)
	self.next_position = fposmod(self.next_position, 1.0)
	self.progress_ratio = fposmod(self.progress_ratio, 1.0)
	

func _right_just_pressed():
	print("right signal received")
	self.next_position = self.next_position - 0.25
	var tween = create_tween()
	tween.tween_property(self, "progress_ratio", self.next_position, 0.25)
	await tween.finished
	print(self.next_position)
	self.next_position = fposmod(self.next_position, 1.0)
	self.progress_ratio = fposmod(self.progress_ratio, 1.0)
	
