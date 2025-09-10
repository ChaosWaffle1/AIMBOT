extends CharacterBody2D

var scrolling = false
var of = Vector2(0,0)

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position() - of
	if scrolling:
		$"../Panel/Credits".position.y = mouse_pos.y
		
	move_and_slide()
	if Input.is_action_pressed("click"):
		scrolling = true
		of = get_global_mouse_position() - $"../Panel/Credits".position
		
	else:
		scrolling = false
