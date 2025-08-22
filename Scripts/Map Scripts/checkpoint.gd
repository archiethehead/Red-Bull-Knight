extends Sprite2D


func _on_checkpoint_area_body_entered(body):
	if body.is_in_group("player") and visible:
		texture = null
		GameState._checkpoint(self)
		$checkpoint_label.visible = true
