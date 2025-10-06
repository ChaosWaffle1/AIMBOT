extends Control


func _on_start_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_credits_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/scroll_credits.tscn")


func _on_version_notes_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/scroll_notes.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
