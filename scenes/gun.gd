extends Node2D

var bullet_scene = preload("res://scenes/bullet.tscn")

func _physics_process(delta):
	$Pivot.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("click"):
		fire()
		
func fire():
	print("gun fired")
	var spread = PI/2
	var num = 100
	for i in range(num):
		var bullet = bullet_scene.instantiate()
		bullet.position = $Pivot/Barrel.global_position + Vector2(2,0).rotated($Pivot.rotation)
		bullet.apply_impulse(Vector2(100,0).rotated($Pivot.global_rotation + spread*(2*(float(i)/float(num-1))-1)))
		get_tree().current_scene.add_child(bullet)
