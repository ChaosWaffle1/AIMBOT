class_name LevelManager
extends Node

var level: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connect_bullet_signals(bullet):
	bullet.hit_robot.connect(advance_level)	
	
func advance_level():
	var f_path = "res://scenes/levels/level_" + str(level + 1) + ".tscn"
	if ResourceLoader.exists(f_path):
		level += 1
		print("Changing to level " + str(level))
		get_tree().change_scene_to_file(f_path)
	else:
		printerr("No level " + str(level + 1) + " scene found. Path:" + f_path)
