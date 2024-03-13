class_name Brick
extends Node3D

@onready var highlight_mesh = $HighlightMesh
@onready var brick_mesh_0 = $brick0
@onready var brick_mesh_1 = $brick1
@onready var brick_mesh_2 = $brick2
@onready var brick_mesh_3 = $brick3
@onready var brick_mesh_4 = $Blank

@onready var state = get_node("/root/State")

@onready var brick_health: int = 4
const MAX_BRICK_HEALTH: int = 4

@onready var brick_meshes: Dictionary = {
	4: brick_mesh_0,
	3: brick_mesh_1,
	2: brick_mesh_2,
	1: brick_mesh_3,
	0: brick_mesh_4
}

func _ready():
	update_mesh()

func _on_click_box_mouse_entered():
	if state.get_state() == state.Mode.WALL_VIEW:
		highlight_mesh.visible = true

func _on_click_box_mouse_exited():
	highlight_mesh.visible = false

func _on_click_box_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			highlight_mesh.visible = false
			SignalBus.brick_clicked.emit(self, self.get_parent())
			
func update_mesh() -> void:
	for i in MAX_BRICK_HEALTH+1:
		if i == brick_health:
			brick_meshes[i].visible = true
		else:
			brick_meshes[i].visible = false

func decrement_health() -> void:
	if brick_health > 0:
		brick_health -= 1
		update_mesh()
	
func set_health(value: int) -> void:
	brick_health = clampi(value, 0, MAX_BRICK_HEALTH)
	update_mesh()
