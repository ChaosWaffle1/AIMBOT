extends StaticBody2D

@onready var explosion_sfx = $ExplosionSFX 
@onready var explosion_particles = $ExplosionParticles
@onready var sprite = $Sprite2D

var dying = false
var angular_velocity = 0
const angular_acceleration = 50

func explode():
	explosion_particles.emitting = true
	explosion_sfx.play()
	dying = true

func _process(delta: float):
	if dying:
		angular_velocity += angular_acceleration*delta
		rotation += angular_velocity*delta
	
