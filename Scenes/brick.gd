class_name Brick
extends Node3D

@onready var highlight_mesh = $HighlightMesh
@onready var brick_mesh_0 = $brick0
@onready var brick_mesh_1 = $brick1
@onready var brick_mesh_2 = $brick2
@onready var brick_mesh_3 = $brick3
@onready var brick_mesh_4 = $Blank
@onready var fake_brick_mesh = $FakeBrick
@onready var particles = $GPUParticles3D

@onready var state = get_node("/root/State")
@onready var signal_bus = get_node("/root/SignalBus")

@onready var brick_health: int = 4
const MAX_BRICK_HEALTH: int = 4
@onready var rotation_ticks = Vector3i(0, 0, 0)
@onready var fake_brick_rotation_ticks = Vector3i(0, 0, 0)

@export var shake_amount = 0.01
@export var shake_duration = 0.1

@onready var brick_meshes: Dictionary = {
	4: brick_mesh_0,
	3: brick_mesh_1,
	2: brick_mesh_2,
	1: brick_mesh_3,
	0: brick_mesh_4
}

func _ready():
	update_mesh()
	signal_bus.left_panel_left_button.connect(y_clockwise)
	signal_bus.left_panel_right_button.connect(y_counterclockwise)
	signal_bus.top_panel_left_button.connect(z_counterclockwise)
	signal_bus.top_panel_right_button.connect(z_clockwise)
	signal_bus.bottom_panel_left_button.connect(x_counterclockwise)
	signal_bus.bottom_panel_right_button.connect(x_clockwise)

func _on_click_box_mouse_entered():
	if state.get_state() == state.Mode.WALL_VIEW:
		highlight_mesh.visible = true

func _on_click_box_mouse_exited():
	highlight_mesh.visible = false

func _on_click_box_input_event(camera, event, position, normal, shape_idx):
	# from wall selection
	#print(camera, Time.get_ticks_msec())
	if state.get_state() == state.Mode.WALL_VIEW:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
				highlight_mesh.visible = false
				SignalBus.brick_clicked.emit(self, self.get_parent())
				
	# from brick repair
	if state.get_state() == state.Mode.BRICK_VIEW:
		# only if this brick selected
		if state.get_brick_selection() == self:
			handle_tool(event)
	
func update_mesh() -> void:
	for i in MAX_BRICK_HEALTH+1:
		if i == brick_health:
			brick_meshes[i].visible = true
			brick_meshes[i].rotation_degrees = 5 * rotation_ticks
		else:
			brick_meshes[i].visible = false
			brick_meshes[i].rotation_degrees = 5 * rotation_ticks

func decrement_health() -> void:
	if brick_health > 0:
		brick_health -= 1
		update_mesh()
		particles.amount = 4
		particles.emitting = true
		shake()
		# good place to change the fake brick rotation
		randomize_fake_rotation()
		signal_bus.brick_health_changed.emit(-1)
	
func set_health(value: int) -> void:
	var difference = value - brick_health
	brick_health = clampi(value, 0, MAX_BRICK_HEALTH)
	update_mesh()
	particles.amount = 10
	particles.emitting = true
	signal_bus.brick_health_changed.emit(difference)
	
func handle_tool(event: InputEvent) -> void:
	
	# event: position is the viewport position
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			# handle chisel
			if state.get_tool_state() == state.Tool.CHISEL and brick_health > 0:
				signal_bus.play_sfx.emit("res://Assets/Resources/chisel.wav")
				set_health(0)
				randomize_fake_rotation()
				
			# handle brick
			if state.get_tool_state() == state.Tool.BRICK and brick_health == 0:
				var tween = create_tween()
				signal_bus.play_sfx.emit("res://Assets/Resources/slide.wav")
				tween.tween_property(fake_brick_mesh, "position", Vector3.ZERO, 0.5)
				await tween.finished
				rotation_ticks = fake_brick_rotation_ticks
				fake_brick_mesh.visible = false
				set_health(4)
				signal_bus.brick_ticks_changed.emit(self)
		
	# handle fake brick movement
	if state.get_tool_state() == state.Tool.BRICK and brick_health == 0:
		fake_brick_mesh.visible = true
		var fake_brick_position = compute_mouse_position_in_3d(event)
		fake_brick_mesh.position = fake_brick_position - Vector3(-2, 0, 0)
		
	# hide fake brick if not brick tool
	if state.get_tool_state() != state.Tool.BRICK:
		fake_brick_mesh.visible = false
		
func shake() -> void:
	# make random directions/amounts
	var x_shake = randf_range(-shake_amount, shake_amount) + self.position.x
	var y_shake = randf_range(-shake_amount, shake_amount) + self.position.y
	var z_shake = randf_range(-shake_amount, shake_amount) + self.position.z
	
	var original_position = self.position
	
	# tween quickly
	var tween = create_tween()
	tween.parallel()
	tween.chain().tween_property(self, "position", Vector3(x_shake, y_shake, z_shake), shake_duration/2)
	tween.chain().tween_property(self, "position", original_position, shake_duration/2)
	
func compute_mouse_position_in_3d(event: InputEvent) -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var brick_to_cam_distance = abs((camera.global_position - self.global_position).length())
	var global_fake_brick_position = camera.project_position(event["position"], brick_to_cam_distance)
	return self.to_local(global_fake_brick_position)
	
func randomize_fake_rotation() -> void:
	fake_brick_rotation_ticks = Vector3i(randi_range(-2, 2), randi_range(-2, 2), randi_range(-2, 2))
	fake_brick_mesh.rotation_degrees = 5 * fake_brick_rotation_ticks
	
func add_rotation_ticks(amount: Vector3i) -> void:
	print("adding ticks")
	for element in 3:
		if rotation_ticks[element] + amount[element] <= 2 and rotation_ticks[element] + amount[element] >= -2:
			print(rotation_ticks[element] + amount[element])
			rotation_ticks[element] += amount[element]
		else:
			shake()
			break
	update_mesh()
	signal_bus.brick_ticks_changed.emit(self)
	
func get_total_ticks() -> int:
	var sum = 0
	for element in 3:
		sum += abs(rotation_ticks[element])
	return sum

func y_counterclockwise():
	if state.get_brick_selection() == self:
		add_rotation_ticks(Vector3i(0, 1, 0))
	
func y_clockwise():
	if state.get_brick_selection() == self:
		add_rotation_ticks(Vector3i(0, -1, 0))
	
func x_counterclockwise():
	if state.get_brick_selection() == self:
		add_rotation_ticks(Vector3i(1, 0, 0))
	
func x_clockwise():
	if state.get_brick_selection() == self:
		add_rotation_ticks(Vector3i(-1, 0, 0))
	
func z_counterclockwise():
	if state.get_brick_selection() == self:
		add_rotation_ticks(Vector3i(0, 0, 1))
	
func z_clockwise():
	if state.get_brick_selection() == self:
		add_rotation_ticks(Vector3i(0, 0, -1))
