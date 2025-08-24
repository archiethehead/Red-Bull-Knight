extends CanvasLayer

func _switch_state():
	visible = !visible
	$resume_button.disabled = !$resume_button.disabled
	$checkpoint_button.disabled = !$checkpoint_button.disabled
	$exit_button.disabled = !$exit_button.disabled


func _on_resume_button_pressed():
	Engine.time_scale = 1
	GameState._unpause()


func _on_exit_button_pressed():
	Engine.time_scale = 1
	GameState.reloading = false
	get_tree().change_scene_to_file("res://Scenes/Game Scenes/main_menu.tscn")


func _on_checkpoint_button_pressed() -> void:
	Engine.time_scale = 1
	GameState._unpause()
	GameState._reload_level()
