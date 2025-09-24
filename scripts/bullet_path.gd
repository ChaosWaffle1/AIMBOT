class_name BulletPath
extends Node2D

@export_range(0,10,1,"or_greater") var bounces: int
@export_range(0,600,0.1,"or_greater") var cast_radius: float = 300
@export var debug_path_enabled: bool

@onready var debug_path = $DebugPath

var enabled: bool = true

func _ready():
	if debug_path_enabled:
		debug_path.visible = true
	else:
		debug_path.visible = false		


func _physics_process(delta: float) -> void:
	if enabled:
		print("firing ray")
		fire()
	enabled = false

func fire():
	var ray = RayCast2D.new()
	add_child(ray)
	ray.enabled = true
	ray.global_position = global_position
	ray.target_position = Vector2(cast_radius,0) #cast_radius=300
	print(ray.target_position)
	ray.force_raycast_update() #needed since it is created outside of physics process
	if ray.is_colliding():
		print("hit")
		var source = ray.global_position
		var hit = ray.get_collision_point()
		
		debug_path.add_point(source)
		debug_path.add_point(hit)
	else:
		print("miss")
