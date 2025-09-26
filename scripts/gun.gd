extends Node2D

@export var display_debug = false

@onready var pivot = $Pivot
@onready var barrel = $Pivot/Barrel
@onready var laser = $Laser
@onready var laser_cast = $Pivot/Barrel/LaserCast

@onready var bullet_ref = load("res://scenes/bullet.tscn")

func _physics_process(delta):
	pivot.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("click"):
		fire()
		
	var barrelPos = barrel.global_position
	barrelPos.x -= 16
	laser.set_point_position(0, to_local(barrelPos))
	if laser_cast.is_colliding():
		var colPos = laser_cast.get_collision_point()
		colPos.x -= 16
		laser.set_point_position(1, to_local(colPos))
		
func fire():
	var bullet: Node2D = bullet_ref.instantiate()
	get_tree().get_current_scene().add_child(bullet)	# set parent of path to global scene (the level)
	bullet.global_position = barrel.global_position
	bullet.rotation = pivot.rotation
