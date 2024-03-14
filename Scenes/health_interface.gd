class_name HealthInterface
extends Control

@onready var signal_bus = get_node("/root/SignalBus")
@onready var label = $RichTextLabel

func _ready():
	signal_bus.health_totals_changed.connect(_change_health)
	label.text = "100/100"

func _change_health(health, max):
	label.text = str(health) + "/" + str(max)
