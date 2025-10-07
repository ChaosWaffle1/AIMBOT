class_name LevelManager
extends Node

var level: int = 1

const level_advance_time = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connect_bullet_signals(bullet):
	# why the fuck did this randomly stop working
	# TODO fix this
	bullet.hit_robot.connect(get_tree().get_first_node_in_group("robot").explode)
	bullet.hit_robot.connect(get_tree().get_first_node_in_group("player").win)

	bullet.hit_player.connect(get_tree().get_first_node_in_group("player").die)
	bullet.hit_robot.connect(advance_level)	
	bullet.hit_player.connect(restart_level)

func restart_level():
	await get_tree().create_timer(0.5*level_advance_time).timeout
	get_tree().reload_current_scene()
	GlobalVars.moveToggled = false

func advance_level():
	print("called avance level")
	await get_tree().create_timer(level_advance_time).timeout
	
	var f_path = "res://scenes/levels/level_" + str(level + 1) + ".tscn"
	if ResourceLoader.exists(f_path):
		level += 1
		print("Changing to level " + str(level))
		get_tree().change_scene_to_file(f_path)
	else:
		printerr("No level " + str(level + 1) + " scene found. Path:" + f_path)

func resume_level():
	var f_path = "res://scenes/levels/level_" + str(level) + ".tscn"
	if ResourceLoader.exists(f_path):
		print("Changing to level " + str(level))
		get_tree().change_scene_to_file(f_path)
	else:
		printerr("No level " + str(level) + " scene found. Path:" + f_path)
