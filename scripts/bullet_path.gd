extends Node2D

var enabled: bool = true

@export var bounces: int
@export var cast_radius: float = 300
@onready var debug_path: Line2D = $DebugPath

func _physics_process(delta: float) -> void:
	if enabled:
		fire()
	enabled = false

func fire():
	print("fire() function")
	var ray = RayCast2D.new()
	add_child(ray)
	ray.enabled = true
	ray.global_position = global_position
	ray.target_position = Vector2(cast_radius,0)
	
	ray.force_raycast_update() #needed since it is created outside of physics process
	if ray.is_colliding():
		print("hit")
		var source = ray.global_position		# must be global due to get_collision_point()
		var hit = ray.get_collision_point()	# always returns global position
		#print("Source:\t" + str(source))
		#print("Hit:\t" + str(hit))
		debug_path.add_point(to_local(source))
		debug_path.add_point(to_local(hit))
	else:
		print("miss")
		pass
