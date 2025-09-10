extends Button

func _on_button_up() -> void:
	GlobalSFX.button_click()

func _on_mouse_entered() -> void:
	GlobalSFX.button_hover()
