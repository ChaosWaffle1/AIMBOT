extends CharacterBody2D


var SPEED = 80.0
var JUMP_VELOCITY = -300.0

@onready var sprite = $AnimatedSprite2D 
@onready var sfx_gun_reload = $GunReload

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Toggle between regular movement and "aim mode"
	if Input.is_action_just_pressed("right_click") and is_on_floor() and not GlobalVars.moveToggled:
		SPEED = 0
		JUMP_VELOCITY = 0
		GlobalVars.moveToggled = true
		sfx_gun_reload.pitch_scale = randf_range(0.9,1.1)
		sfx_gun_reload.play()
		
	elif Input.is_action_just_pressed("right_click") and GlobalVars.moveToggled:
		SPEED = 80.0
		JUMP_VELOCITY = -300.0
		GlobalVars.moveToggled = false
	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if GlobalVars.moveToggled:
		const center = -90
		const range = 30
		var angle = 180*$Gun/Pivot.global_rotation/PI
		if center - range <= angle and angle <= center + range:
			sprite.play("shoot_up")
		else:
			sprite.play("shoot_side")
	elif direction == 0:
		sprite.play("idle")
	else:
		sprite.play("walk")
	
	if direction > 0 and not GlobalVars.moveToggled:
		sprite.flip_h = false
	elif direction < 0 and not GlobalVars.moveToggled:
		sprite.flip_h = true
	elif GlobalVars.moveToggled and get_global_mouse_position().x < $Gun.global_position.x:
		sprite.flip_h = true
	elif GlobalVars.moveToggled and get_global_mouse_position().x > $Gun.global_position.x:
		sprite.flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
