extends Sprite2D


func _on_level_finish_area_body_entered(body):
	if body.is_in_group("player"):
		GameState.reloading = false
		visible = false
		GameState.call_deferred("_level_finished")
