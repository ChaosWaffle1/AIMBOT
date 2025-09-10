extends Button

@onready var sfx_select: AudioStreamPlayer = $Select
@onready var sfx_hover: AudioStreamPlayer = $Hover

func _on_button_up() -> void:
	sfx_select.play()

func _on_mouse_entered() -> void:
	sfx_hover.play()
