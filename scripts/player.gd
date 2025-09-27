extends CharacterBody2D


var SPEED = 80.0
var JUMP_VELOCITY = -300.0
var moveToggled = false

@onready var sprite = $AnimatedSprite2D 

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Toggle between regular movement and "aim mode"
	if Input.is_action_just_pressed("moveSwap") and is_on_floor() and moveToggled == false:
		SPEED = 0
		JUMP_VELOCITY = 0
		moveToggled = true
	elif Input.is_action_just_pressed("moveSwap") and moveToggled == true:
		SPEED = 80.0
		JUMP_VELOCITY = -300.0
		moveToggled = false

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
