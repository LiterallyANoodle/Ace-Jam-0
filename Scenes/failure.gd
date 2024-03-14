extends Control

@onready var label = $TextureRect
@onready var signal_bus = get_node("/root/SignalBus")

func _ready():
	self.visible = false
	signal_bus.failure.connect(fail)

func fail():
	self.visible = true
	signal_bus.change_song.emit("res://Assets/Resources/a momentary lapse of the senses.wav")
