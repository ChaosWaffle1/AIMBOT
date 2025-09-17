extends Control


func _on_start_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/base_level.tscn")


func _on_credits_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/scroll_credits.tscn")


func _on_version_notes_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/scroll_notes.tscn")
