extends Node

enum Mode { MAIN_MENU, WALL_VIEW, BRICK_VIEW }

@onready var current_state = Mode.WALL_VIEW

func get_state() -> Mode:
	return current_state
	

func set_state(state: Mode) -> void:
	current_state = state
