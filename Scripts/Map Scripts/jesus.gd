extends CanvasLayer


func _flash():
	$jesus_bell.play()
	for n in range(50):
		await get_tree().create_timer(0.007).timeout
		$jesus_sprite.modulate.a += 0.01
	for n in range(50):
		await get_tree().create_timer(0.007).timeout
		$jesus_sprite.modulate.a -= 0.01
	GameState.damage_screen_on = false
