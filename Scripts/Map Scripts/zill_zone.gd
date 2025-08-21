extends Area2D

@onready var timer = $zill_zone_timer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body._die()
