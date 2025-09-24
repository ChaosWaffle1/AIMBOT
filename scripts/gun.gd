extends Node2D

var bullet_scene = preload("res://scenes/bullet.tscn")
var bullet_speed = 1000

@onready var pivot = $Pivot
@onready var barrel = $Pivot/Barrel
@onready var laser = $Laser
@onready var laser_cast = $Pivot/Barrel/LaserPoint

func _physics_process(delta):
	pivot.look_at(get_global_mouse_position())
	var barrelPos = barrel.global_position
	barrelPos.x -= 16
	laser.set_point_position(0, to_local(barrelPos))
	if Input.is_action_just_pressed("click"):
		fire()
	if laser_cast.is_colliding():
		$CollisionPoint.global_position = laser_cast.get_collision_point()
		var colPos = laser_cast.get_collision_point()
		colPos.x -= 16
		laser.set_point_position(1, to_local(colPos))
		
	
		
func fire():
	print("gun fired")
	
	var bullet = bullet_scene.instantiate()
	bullet.position = barrel.global_position # make bullet position global_pos of barrel
	bullet.apply_impulse(Vector2(bullet_speed,0).rotated(pivot.global_rotation)) # apply velocity to global position of barrel
	get_tree().current_scene.add_child(bullet) # parent bullet to SCENE
