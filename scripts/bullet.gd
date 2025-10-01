extends Node2D

const SLOP = 0.9999

var bounces: int = 0
var finished: bool = false

@export var bullet_speed: float = 50
@export var max_bounces: int = 2

@onready var path: Path2D = $Path
@onready var path_follow: PathFollow2D = $Path/PathFollow
@onready var sight: RayCast2D = $Path/PathFollow/Sight
@onready var debug_line: Line2D = $DebugLine
@onready var kill_switch = $KillSwitch

func _ready() -> void:
	# make unique path to this bullet
	path.curve = Curve2D.new()
	
	# "transfer" the nodes rotation to sight
	sight.target_position = Vector2(1,0).rotated(rotation)
	rotation = 0
	
	path.curve.add_point(sight.position)
	debug_line.add_point(to_local(sight.global_position))

func _physics_process(delta: float) -> void:
	if path.curve.point_count > 500:
		queue_free()
		return
		
	if bounces >= max_bounces:
		if kill_switch.is_stopped():
			kill_switch.start()
		return
		
	var distance_remaining: float = bullet_speed * delta
	var ray: RayCast2D = sight

	ray.force_raycast_update()
	if (ray.global_position + ray.target_position).x < -144:
		pass

	print(str(ray.global_position) + " " + str(ray.global_position + ray.target_position))
	print(ray.is_colliding())
	
	#TODO: WHY DOES THIS NOT REGISTER UNTIL THE NEXT FRAME??????????
	
	while bounces < max_bounces:			
		ray.force_raycast_update() # why do i need this here :(
		if not ray.is_colliding():
			# add target to path as there is no collision this frame
			path.curve.add_point(path.to_local(ray.global_position) + ray.target_position)
			debug_line.add_point(path.to_local(ray.global_position) + ray.target_position)
			path_follow.progress += SLOP*distance_remaining
			return
		
		# ray is colliding from this point on
		bounces += 1
		
		# add hit to path
		var hit: Vector2 = ray.get_collision_point()
		var normal: Vector2 = ray.get_collision_normal()
		#
		#print("bounces:\t" + str(bounces))
		#print("hit:\t\t" + str(hit))
		#print("normal:\t\t" + str(normal)) #WHY IS THE NORMAL VECTOR WRONG
		#print("target:\t\t" + str(ray.target_position))
		
		path.curve.add_point(path.to_local(hit))
		debug_line.add_point(path.to_local(hit))
		
		# subtract off traversed distance before bounce from distance remaining
		var distance_to_hit = (ray.position - ray.to_local(hit)).length()
		path_follow.progress += SLOP*distance_to_hit
		distance_remaining -= SLOP*distance_to_hit
		
		# create a new ray
		var new_ray = RayCast2D.new()
		ray.enabled = true
		add_child(new_ray) 
		
		# position new ray at tip of old ray
		new_ray.position = SLOP*ray.to_local(hit)
		
		# reflect new ray along normal of old ray
		var dir: Vector2 = ray.to_local(hit).bounce(normal).normalized()
		new_ray.target_position = distance_remaining*dir
		
		ray = new_ray
	print()


func _on_timer_timeout() -> void:
	queue_free()
