extends Node2D

@export var display_debug = false

@onready var pivot = $Pivot
@onready var barrel = $Pivot/Barrel
@onready var timer = $Timer
@onready var laser = $Laser
@onready var laser_cast = $Pivot/Barrel/LaserCast
@onready var sfx_gunshot = $Gunshot
@onready var sfx_reload = $Reload


@onready var bullet_ref = load("res://scenes/objects/bullet.tscn")

func _physics_process(delta):
	var notPointingDown = true
	var mouse = get_global_mouse_position()
	if mouse.x > $".".global_position.x - 3.5 and mouse.x < $".".global_position.x + 3.5 and mouse.y > $".".global_position.y:
		notPointingDown = false
	else:
		notPointingDown = true
	if Input.is_action_just_pressed("left_click") and GlobalVars.moveToggled and timer.is_stopped() and notPointingDown:
		fire()
		timer.start()
		sfx_reload.play()
		
	var barrelPos = barrel.global_position
	barrelPos.x -= 16
	laser.set_point_position(0, to_local(barrelPos))
	if laser_cast.is_colliding():
		var colPos = laser_cast.get_collision_point()
		colPos.x -= 16
		laser.set_point_position(1, to_local(colPos))
		
	if GlobalVars.moveToggled:
		laser.visible = true
		barrelPos.y -= 50
		pivot.look_at(mouse)
	else:
		laser.visible = false
		barrelPos.y += 50
		pivot.look_at(barrelPos)
		
func fire():
	sfx_gunshot.pitch_scale = randf_range(0.8, 1.2)
	sfx_gunshot.play()
	var bullet: Node2D = bullet_ref.instantiate()
	get_tree().get_current_scene().add_child(bullet)	# set parent of path to global scene (the level)
	bullet.global_position = barrel.global_position
	bullet.rotation = pivot.rotation
