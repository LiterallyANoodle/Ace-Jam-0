extends Node

enum Mode { MAIN_MENU, WALL_VIEW, BRICK_VIEW }
enum Tool { NONE, CHISEL, BRICK, HAMMER }

@onready var current_state = Mode.WALL_VIEW
@onready var tool_state = Tool.NONE

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
