extends CharacterBody2D


var SPEED = 80.0
var JUMP_VELOCITY = -300.0

@onready var sprite = $AnimatedSprite2D 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Toggle between regular movement and "aim mode"
	if Input.is_action_just_pressed("right_click") and is_on_floor() and not GlobalVars.moveToggled:
		SPEED = 0
		JUMP_VELOCITY = 0
		GlobalVars.moveToggled = true
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
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
