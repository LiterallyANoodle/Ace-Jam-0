class_name Tools_Interface
extends CanvasLayer

@onready var signal_bus = get_node("/root/SignalBus")
@onready var state = get_node("/root/State")

@onready var chisel_button = $HBoxContainer/Chisel
@onready var brick_button = $HBoxContainer/BrickPile
@onready var hammer_button = $HBoxContainer/Hammer

@onready var buttons_array = [ chisel_button, brick_button, hammer_button ]


func _on_chisel_pressed():
	for b in buttons_array:
		b.disabled = false
	chisel_button.disabled = true
	state.set_tool_state(state.Tool.CHISEL)


func _on_brick_pile_pressed():
	for b in buttons_array:
		b.disabled = false
	brick_button.disabled = true
	state.set_tool_state(state.Tool.BRICK)


func _on_hammer_pressed():
	for b in buttons_array:
		b.disabled = false
	hammer_button.disabled = true
	state.set_tool_state(state.Tool.HAMMER)
