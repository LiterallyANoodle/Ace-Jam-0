class_name FakeBrick
extends Node3D

@onready var signal_bus = get_node("/root/SignalBus")

func _ready():
	signal_bus.back_pressed.connect(_on_back_pressed)
	
func _on_back_pressed():
	self.visible = false
