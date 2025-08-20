extends Area2D

@onready var timer = $zill_zone_timer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Engine.time_scale = 0.1
		body._die()
		timer.start()


func _on_zill_zone_timer_timeout() -> void:
	get_tree().reload_current_scene()
