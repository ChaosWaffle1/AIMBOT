extends Node2D

var enabled: bool = true

@export var max_bounces: int = 20
@export var cast_radius: float = 300

@onready var path: Path2D = $Path
@onready var debug_line: Line2D = $DebugLine

func _ready() -> void:
	path.curve = Curve2D.new()

func _physics_process(delta: float) -> void:
	if enabled:
		fire()
	enabled = false

func fire():
	var bounces = 0
	var old_ray = null
	var old_hit = null
	var old_normal = null
	
	# set global rotation of bullet path to 0 ("transfers" the rotation to the ray as opposed to the big parent node)
	var init_angle = global_rotation
	global_rotation = 0
	
	while bounces <= max_bounces:
		# create a new ray
		var ray = RayCast2D.new()
		ray.enabled = true
		
		# parent to old ray, or base node if no old_ray
		if old_ray:
			old_ray.add_child(ray)
		else:
			add_child(ray) # first ray cast
		
		# position new ray at tip of old_ray unless this is the first ray
		if old_hit:
			ray.position = old_ray.to_local(old_hit) 

		# set other stuff
		if old_ray:
			var dir: Vector2 = old_ray.to_local(old_hit).bounce(old_normal).normalized()
			ray.target_position = cast_radius*dir
		else:
			ray.target_position = Vector2(cast_radius,0).rotated(init_angle)

		# must be global due to get_collision_point()
		var source = ray.global_position		
		var hit = null
		
		# needed since it is created outside of physics process
		ray.force_raycast_update() 
		if ray.is_colliding():			
			hit = ray.get_collision_point()	# always global
			old_hit = source.lerp(hit, 0.999) # slight lerp to avoid next ray hitting same wall 
			old_normal = ray.get_collision_normal()
		else:
			hit = ray.target_position + source
			
		# must be local to BulletPath so DebugLine renders correctly
		if not old_ray:	# adds extra point if first ray
			path.curve.add_point(to_local(source)) 
			debug_line.add_point(to_local(source))
		path.curve.add_point(to_local(hit))
		debug_line.add_point(to_local(hit))
		
		if ray.is_colliding():
			bounces += 1
			old_ray = ray
		else:
			break


func _on_bullet_path_completed() -> void:
	#path.curve.clear_points() #for some reason godot doesn't reset the path after queue_free() like its global for some reason
	queue_free()
