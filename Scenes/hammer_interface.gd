class_name HammerInterface
extends Control

@onready var state = get_node("/root/State")
@onready var signal_bus = get_node("/root/SignalBus")
@onready var camera_transition = get_node("/root/CameraTransition")
@onready var front_camera = $HBoxContainer/FrontContainer/Front/FrontCamera3D
@onready var top_camera = $HBoxContainer/VBoxContainer/TopContainer/Top/TopCamera3D
@onready var side_camera = $HBoxContainer/VBoxContainer/SideContainer/SideAxis/SideCamera3D
@onready var vbox = $HBoxContainer/VBoxContainer
@onready var dial_level = $Level/Path2D/LevelPathFollow2D
@onready var dial_plumb = $Plumb/Path2D/PlumbPathFollow2D
@onready var dial_square = $Square/Path2D/SquarePathFollow2D
@onready var dials = [ dial_level, dial_square, dial_plumb ]

@onready var opened = false
@onready var brick_level = 0
@onready var brick_plumb = 0
@onready var brick_square = 0
@onready var brick_ticks = [ brick_level, brick_square, brick_plumb ]

@export var top_cam_height = 2
@export var side_cam_distance = 2

func _ready():
	signal_bus.brick_selected.connect(_on_brick_selected)
	signal_bus.back_pressed.connect(_on_back_pressed)
	signal_bus.brick_ticks_changed.connect(_on_brick_ticks_updated)
	self.visible = false

func open():
	if not opened:
		vbox.size_flags_stretch_ratio = 0
		self.visible = true
		var tween = create_tween()
		tween.tween_property(vbox, "size_flags_stretch_ratio", 1, 0.25)
		await tween.finished
		dial_level.visible = true
		dial_plumb.visible = true
		dial_square.visible = true
		opened = true
	
func close():
	if opened:
		vbox.size_flags_stretch_ratio = 1
		dial_level.visible = false
		dial_plumb.visible = false
		dial_square.visible = false
		var tween = create_tween()
		tween.tween_property(vbox, "size_flags_stretch_ratio", 0, 0.25)
		await tween.finished
		self.visible = false
		opened = false
		
func update_dials() -> void:
	const placements = {
		-2: 0,
		-1: 0.2612,
		0: 0.4883,
		1: 0.7523,
		2: 1
	}
	for i in 3:
		dials[i].progress_ratio = placements[brick_ticks[i]]
	
# set up the cameras to focus this brick without modifying the outside cameras
func _on_brick_selected(brick: Brick, wall: Wall, received_camera: Camera3D) -> void:
	# front, easy
	camera_transition.copy_camera3d(received_camera, front_camera)
	# top
	top_camera.rotation = front_camera.rotation
	top_camera.global_position = brick.to_global(Vector3(-0.5, top_cam_height, 0)) # place it 2m above the brick center
	top_camera.rotation.x += deg_to_rad(270)
	top_camera.near = top_cam_height - 1 - 1 # make the near cull right above the selected brick top so we don't have any other bricks in the way
	# side
	side_camera.rotation = front_camera.rotation
	side_camera.global_position = brick.to_global(Vector3(0, 0.5, -side_cam_distance)) # place to the side
	side_camera.rotation.y += deg_to_rad(90) # rotate to look
	side_camera.near = side_cam_distance - 1.88 - 1 # cull everything in front + margin
	
	# set dials
	brick_level = brick.rotation_ticks[0]
	brick_square = brick.rotation_ticks[1]
	brick_plumb = brick.rotation_ticks[2]
	update_dials()
	
func _on_brick_ticks_updated(brick: Brick):
	brick_level = brick.rotation_ticks[0]
	brick_square = brick.rotation_ticks[1]
	brick_plumb = brick.rotation_ticks[2]
	brick_ticks = [ brick_level, brick_square, brick_plumb ]
	update_dials()
	
func _on_back_pressed():
	close()

# workaround for triple screen
func _send_hammer_buttons(button: String):
	
	const signals: Dictionary = {
		
		"LeftPaneLeftButton": "left_panel_left_button",
		"LeftPaneRightButton": "left_panel_right_button",
		"TopPaneLeftButton": "top_panel_left_button",
		"TopPaneRightButton": "top_panel_right_button",
		"BottomPaneLeftButton": "bottom_panel_left_button",
		"BottomPaneRightButton": "bottom_panel_right_button",
		
	}

	signal_bus.emit_signal(signals[button])
	signal_bus.play_sfx.emit("res://Assets/Resources/hammer.wav")
	
	brick_level = state.get_brick_selection().rotation_ticks[0]
	brick_square = state.get_brick_selection().rotation_ticks[1]
	brick_plumb = state.get_brick_selection().rotation_ticks[2]
	update_dials()
