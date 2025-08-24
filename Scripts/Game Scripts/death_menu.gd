extends CanvasLayer


func _on_checkpoint_button_pressed() -> void:
	get_tree().paused = false
	GameState._reload_level()


func _on_restart_button_pressed() -> void:
	GameState.reloading = false
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_exit_button_pressed() -> void:
	GameState.reloading = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Game Scenes/main_menu.tscn")

func _switch_state():
	get_tree().paused = true
	visible = !visible
	$restart_button.disabled = !$restart_button.disabled
	$checkpoint_button.disabled = !$checkpoint_button.disabled
	$exit_button.disabled = !$exit_button.disabled
