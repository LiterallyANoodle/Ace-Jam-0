extends Node

# key controls
signal brick_clicked(brick: Brick, wall: Wall)
signal back_pressed

# interface buttons
signal select_chisel
signal select_bricks
signal select_hammer
signal brick_selected(brick: Brick, wall: Wall, front_camera: Camera3D)

# particles
signal brick_health_changed(difference: int)
signal health_totals_changed(health: int, max: int)

# mouse in triple screen
signal left_panel_left_button
signal left_panel_right_button
signal top_panel_left_button
signal top_panel_right_button
signal bottom_panel_left_button
signal bottom_panel_right_button

signal brick_ticks_changed(brick: Brick)

signal play_sfx(sound)
signal change_song(song)

signal failure
