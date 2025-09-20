extends Node2D

var bullet_scene = preload("res://scenes/bullet.tscn")
var bullet_speed = 1000

func _physics_process(delta):
	$Pivot.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("click"):
		fire()
	$CollisionPoint.global_position = $Pivot/Barrel/LaserPoint.get_collision_point()
		
func fire():
	print("gun fired")
	
	var bullet = bullet_scene.instantiate()
	bullet.position = $Pivot/Barrel.global_position # make bullet position global_pos of barrel
	bullet.apply_impulse(Vector2(bullet_speed,0).rotated($Pivot.global_rotation)) # apply velocity to global position of barrel
	get_tree().current_scene.add_child(bullet) # parent bullet to SCENE
