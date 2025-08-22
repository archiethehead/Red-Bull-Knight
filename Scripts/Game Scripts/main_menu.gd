extends Control


func _on_exit_game_pressed() -> void:
	get_tree().quit(0)


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Map Scenes/Maps/test_map.tscn")

func _ready():
	get_tree().paused = false
