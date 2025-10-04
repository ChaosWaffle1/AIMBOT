extends Node2D

const SLOP = 0.9999

var bounces: int = 0
var has_hit_robot: bool = false
var has_hit_player: bool = false

@export var bullet_speed: float = 2000
@export var max_bounces: int = 20

@onready var path: Path2D = $Path
@onready var path_follow: PathFollow2D = $Path/PathFollow
@onready var debug_line: Line2D = $DebugLine
@onready var kill_switch = $KillSwitch
@onready var bullet_sprite = $Path/PathFollow/BulletSprite
@onready var ricochet_sounds = $Path/PathFollow/RichochetSounds

signal hit_robot
signal hit_player

func _ready() -> void:
	# make unique path to this bullet
	path.curve = Curve2D.new()
	
	path.curve.add_point(path.position)
	debug_line.add_point(path.position)
	
	GameManager.get_node("LevelManager").connect_bullet_signals(self)
	
func _physics_process(delta: float) -> void:
	var first_ray = true
	if path.curve.point_count > 500:
		queue_free()
		return
	var go = keep_going()
	if not go:
		if has_hit_robot:
			hit_robot.emit()
		elif has_hit_player:
			hit_player.emit()
		elif bounces >= max_bounces + 1:
			pass
		if kill_switch.is_stopped():
			kill_switch.start()
		return
		
	var distance_remaining: float = bullet_speed * delta
	var ray: RayCast2D = RayCast2D.new()
	var orig_ray: RayCast2D = ray
	ray.position = to_local(bullet_sprite.global_position)
	ray.target_position = distance_remaining * Vector2.RIGHT.rotated(path_follow.global_rotation)
	global_rotation = 0
	
	add_child(ray)
		
	while go:			
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
		var collider = ray.get_collider()
		if collider.is_in_group("robot"):
			print("hit robot")
			has_hit_robot = true
		if collider.is_in_group("player"):
			print("hit player")
			has_hit_player = true
				
		path.curve.add_point(path.to_local(hit))
		debug_line.add_point(path.to_local(hit))
		
		# subtract off traversed distance before bounce from distance remaining
		var distance_to_hit = ray.to_local(hit).length()
		path_follow.progress += distance_to_hit
		distance_remaining -= distance_to_hit
		
		go = keep_going()
		if not go: #skip casting new ray if the bullet is done bouncing or has hit something
			continue
		
		# play ricochet sound
		var sound: AudioStreamPlayer2D = ricochet_sounds.get_children().pick_random()
		sound.pitch_scale = randf_range(0.9,1.1)
		sound.attenuation = 6
		sound.play()
		
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
	orig_ray.queue_free()

func keep_going() -> bool:
	return not (has_hit_robot or has_hit_player or bounces >= max_bounces + 1) 

func _on_timer_timeout() -> void:
	queue_free()
