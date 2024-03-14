class_name Tools_Interface
extends CanvasLayer

@onready var signal_bus = get_node("/root/SignalBus")
@onready var state = get_node("/root/State")

@onready var chisel_button = $HBoxContainer/Chisel
@onready var brick_button = $HBoxContainer/BrickPile
@onready var hammer_button = $HBoxContainer/Hammer
@onready var hammer_interface = $HammerInterface

@onready var buttons_array = [ chisel_button, brick_button, hammer_button ]

func _ready():
	signal_bus.back_pressed.connect(_on_back_pressed)

func _on_chisel_pressed():
	if state.failed == false:
		for b in buttons_array:
			b.disabled = false
		chisel_button.disabled = true
		if hammer_interface.opened:
			hammer_interface.close()
		state.set_tool_state(state.Tool.CHISEL)


func _on_brick_pile_pressed():
	if state.failed == false:
		for b in buttons_array:
			b.disabled = false
		brick_button.disabled = true
		if hammer_interface.opened:
			hammer_interface.close()
		state.set_tool_state(state.Tool.BRICK)


func _on_hammer_pressed():
	if state.failed == false:
		for b in buttons_array:
			b.disabled = false
		hammer_button.disabled = true
		if not hammer_interface.opened:
			hammer_interface.open()
		state.set_tool_state(state.Tool.HAMMER)
		
func _on_back_pressed():
	for b in buttons_array:
		b.disabled = false
	state.set_tool_state(state.Tool.NONE)
