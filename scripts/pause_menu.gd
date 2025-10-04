extends Control

func _ready():
	self.visible = false
	
func resume ():
	get_tree().paused = false
	self.visible = false
	
func pause():
	get_tree().paused = true
	self.visible = true
	
func testEsc():
	if Input.is_action_just_pressed("escape"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed() -> void:
	resume()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	resume()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta):
	testEsc()
