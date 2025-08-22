extends CanvasLayer

func _switch_state():
	visible = !visible
	$resume_button.disabled = !$resume_button.disabled
	$exit_button.disabled = !$exit_button.disabled


func _on_resume_button_pressed():
	GameState._unpause()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game Scenes/main_menu.tscn")
