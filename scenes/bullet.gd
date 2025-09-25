extends PathFollow2D

const BULLET_SPEED = 2000

signal path_completed

func _process(delta: float) -> void:
	progress += BULLET_SPEED*delta
	if abs(progress_ratio-1) < 0.01:
		path_completed.emit()
