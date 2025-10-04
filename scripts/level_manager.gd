class_name LevelManager
extends Node

var level: int = 1

const level_advance_time = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connect_bullet_signals(bullet):
	bullet.hit_robot.connect(advance_level)	
	bullet.hit_player.connect(restart_level)

func restart_level():
	get_tree().reload_current_scene()
	GlobalVars.moveToggled = false

func advance_level():
	await get_tree().create_timer(level_advance_time).timeout
	
	var f_path = "res://scenes/levels/level_" + str(level + 1) + ".tscn"
	if ResourceLoader.exists(f_path):
		level += 1
		print("Changing to level " + str(level))
		get_tree().change_scene_to_file(f_path)
	else:
		printerr("No level " + str(level + 1) + " scene found. Path:" + f_path)
