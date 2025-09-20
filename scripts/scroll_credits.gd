extends Node2D




func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
