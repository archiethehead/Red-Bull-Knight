extends CanvasLayer

func _update_health_label():
	$health_label.text =(str(GameState.player_health) + "/" + str(GameState.max_player_health) + " HP")
