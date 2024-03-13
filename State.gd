extends Node

enum Mode { MAIN_MENU, WALL_VIEW, BRICK_VIEW }
enum Tool { CHISEL, BRICK, HAMMER }

@onready var current_state = Mode.WALL_VIEW
@onready var tool_state = Tool.BRICK

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
