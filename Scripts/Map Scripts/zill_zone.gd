extends Area2D

@onready var tile_map: game_state = $"../.."


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		tile_map._update_health(-tile_map.player_health)
