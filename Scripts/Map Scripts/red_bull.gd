extends Sprite2D


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		GameState._update_health(1)
		GameState._update_red_bull(1)
		queue_free()
