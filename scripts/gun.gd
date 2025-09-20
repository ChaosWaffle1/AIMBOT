extends Node2D

var bullet_scene = preload("res://scenes/bullet.tscn")
var bullet_speed = 1000

func _physics_process(delta):
	$Pivot.look_at(get_global_mouse_position())
	var barrelPos = $Pivot/Barrel.global_position
	barrelPos.x -= 16
	$Laser.set_point_position(0, to_local(barrelPos))
	if Input.is_action_just_pressed("click"):
		fire()
	if $Pivot/Barrel/LaserPoint.is_colliding():
		$CollisionPoint.global_position = $Pivot/Barrel/LaserPoint.get_collision_point()
		var colPos = $Pivot/Barrel/LaserPoint.get_collision_point()
		colPos.x -= 16
		$Laser.set_point_position(1, to_local(colPos))
		
	
		
func fire():
	print("gun fired")
	
	var bullet = bullet_scene.instantiate()
	bullet.position = $Pivot/Barrel.global_position # make bullet position global_pos of barrel
	bullet.apply_impulse(Vector2(bullet_speed,0).rotated($Pivot.global_rotation)) # apply velocity to global position of barrel
	get_tree().current_scene.add_child(bullet) # parent bullet to SCENE
