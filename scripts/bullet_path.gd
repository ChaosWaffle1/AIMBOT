extends Node2D

var bounces: int = 0
var finished: bool = false

@export var bullet_speed: float = 10000
@export var max_bounces: int = 10

@onready var path: Path2D = $Path
@onready var path_follow: PathFollow2D = $Path/PathFollow
@onready var sight: RayCast2D = $Path/PathFollow/Sight
@onready var debug_line: Line2D = $DebugLine

func _ready() -> void:
	# make unique path to this bullet
	path.curve = Curve2D.new()
	
	# "transfer" the nodes rotation to sight
	sight.target_position = Vector2(bullet_speed,0).rotated(rotation)
	rotation = 0
	
	path.curve.add_point(sight.position)
	debug_line.add_point(to_local(sight.global_position))

# algorithm to deal with multiple bounces in a frame
#	physics_process():
#		add initial point
#		set old_ray to sight
#		begin loop:
#			if old_ray doesn't collide:
#				add point to line
#				move bullet
#				RETURN
#			compute distance left
#			make new ray
#				- position new ray at tail of old ray
#				- reflect new ray along normal of old ray
#				- scale size of new ray to distance_remaining
#			force raycast update

func _physics_process(delta: float) -> void:
	if bounces >= max_bounces:
		return
	var distance_remaining: float = bullet_speed * delta
	var ray: RayCast2D = sight
	while bounces < max_bounces:			
		ray.force_raycast_update() # why do i need this here :(
		if not ray.is_colliding():
			# add target to path as there is no collision this frame
			path.curve.add_point(ray.target_position)
			debug_line.add_point(ray.target_position)
			path_follow.progress += distance_remaining
			return
			
		bounces += 1
		# add hit to path
		var hit: Vector2 = ray.get_collision_point()
		var normal: Vector2 = ray.get_collision_normal()
		path.curve.add_point(hit)
		debug_line.add_point(hit)
		
		# subtract off traversed distance before bounce from distance remaining
		var distance_to_hit = (ray.position - ray.to_local(hit)).length()
		path_follow.progress += distance_to_hit

		distance_remaining -= distance_to_hit

		
		# create a new ray
		var new_ray = RayCast2D.new()
		ray.enabled = true
		ray.add_child(new_ray) 
		
		# position new ray at tip of old ray
		new_ray.position = ray.to_local(hit) 
		
		# reflect new ray along normal of old ray
		var dir: Vector2 = ray.to_local(hit).bounce(normal).normalized()
		new_ray.target_position = distance_remaining*dir
		
		ray = new_ray
