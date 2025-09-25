extends Node2D

@export var display_debug = false

@onready var pivot = $Pivot
@onready var barrel = $Pivot/Barrel
@onready var laser = $Laser
@onready var laser_cast = $Pivot/Barrel/LaserCast

@onready var bullet_path_tscn = load("res://scenes/bullet_path.tscn")

func _physics_process(delta):
	pivot.look_at(get_global_mouse_position())
	var barrelPos = barrel.global_position
	barrelPos.x -= 16
	laser.set_point_position(0, to_local(barrelPos))
	if Input.is_action_just_pressed("click"):
		fire()
	if laser_cast.is_colliding():
		var colPos = laser_cast.get_collision_point()
		colPos.x -= 16
		laser.set_point_position(1, to_local(colPos))
		
func fire():
	var path: Node2D = bullet_path_tscn.instantiate()
	get_tree().get_current_scene().add_child(path)	# set parent of path to global scene (the level)
	path.global_position = barrel.global_position
	path.rotation = pivot.rotation
