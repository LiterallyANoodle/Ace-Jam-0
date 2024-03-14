extends Node

enum Mode { MAIN_MENU, WALL_VIEW, BRICK_VIEW }
enum Tool { NONE, CHISEL, BRICK, HAMMER }

@onready var signal_bus = get_node("/root/SignalBus")

@onready var current_state = Mode.WALL_VIEW
@onready var tool_state = Tool.NONE
@onready var selected_brick = null
@onready var selected_brick_deficit = 0
@onready var failed = false

@onready var castle_health: int = 100
@onready var max_castle_health: int = 100

@onready var hammer_cursor_normal: Resource = load("res://Assets/RawTextures/hammer_cursor_normal.png")
@onready var brick_cursor_normal: Resource = load("res://Assets/RawTextures/brick_cursor_normal.png")
@onready var chisel_cursor_normal: Resource = load("res://Assets/RawTextures/chisel_cursor_normal.png")

@onready var cursors: Dictionary = {
	Tool.NONE: null, 
	Tool.CHISEL: chisel_cursor_normal,
	Tool.BRICK: brick_cursor_normal,
	Tool.HAMMER: hammer_cursor_normal,
}

func _ready():
	randomize()
	signal_bus.back_pressed.connect(_on_back_pressed)
	signal_bus.brick_health_changed.connect(_on_brick_health_changed)

func get_state() -> Mode:
	return current_state

func set_state(state: Mode) -> void:
	current_state = state
	
func get_tool_state() -> Tool:
	return tool_state
	
func set_tool_state(state: Tool) -> void:
	tool_state = state
	update_cursor()
	
func update_cursor() -> void:
	Input.set_custom_mouse_cursor(cursors[tool_state], Input.CURSOR_ARROW)
	
func set_brick_selection(brick: Brick) -> void:
	if brick != null:
		selected_brick_deficit = brick.get_total_ticks()
	else:
		selected_brick_deficit = 0
	selected_brick = brick
	
func get_brick_selection() -> Brick:
	return selected_brick
	
func _on_back_pressed():
	var change_in_ticks = selected_brick_deficit - selected_brick.get_total_ticks()
	max_castle_health += change_in_ticks
	signal_bus.health_totals_changed.emit(castle_health, max_castle_health)
	if max_castle_health <= 0:
		signal_bus.failure.emit()
		failed = true
	
func _on_brick_health_changed(amount: int) -> void:
	castle_health += amount
	castle_health = clamp(castle_health, 0, max_castle_health)
	signal_bus.health_totals_changed.emit(castle_health, max_castle_health)
	if castle_health <= 0:
		signal_bus.failure.emit()
		failed = true
		
