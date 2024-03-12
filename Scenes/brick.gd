class_name Brick
extends Node3D

@onready var highlight_mesh = $HighlightMesh

func _on_click_box_mouse_entered():
	highlight_mesh.visible = true

func _on_click_box_mouse_exited():
	highlight_mesh.visible = false

func _on_click_box_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			SignalBus.brick_clicked.emit(self, self.get_parent())
