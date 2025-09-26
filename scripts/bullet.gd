extends PathFollow2D

const BULLET_SPEED = 1000

signal path_completed

var old_progress = 0

func _process(delta: float) -> void:
	pass
	#progress += BULLET_SPEED*delta
	#if progress - old_progress < 0:
		#progress -= BULLET_SPEED*delta
		#path_completed.emit()
	#old_progress = progress
	#print(progress)
