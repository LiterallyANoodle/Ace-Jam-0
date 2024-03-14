extends AudioStreamPlayer

@onready var sfx = $SFX
@onready var signal_bus = get_node("/root/SignalBus")

@onready var changed_song = false

# Called when the node enters the scene tree for the first time.
func _ready():
	signal_bus.play_sfx.connect(play_sfx)
	signal_bus.change_song.connect(change_song)
	
func play_sfx(audio):
	sfx.stop()
	sfx.set_stream(load(audio))
	sfx.play()
	
func change_song(song):
	if not changed_song:
		changed_song = true
		self.stop()
		self.set_stream(load(song))
		self.volume_db = 0
		self.play()
