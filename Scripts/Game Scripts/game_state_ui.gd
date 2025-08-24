extends CanvasLayer

@onready var red_bull_can: Sprite2D = $Cans/red_bull_can
@onready var red_bull_can_2: Sprite2D = $Cans/red_bull_can_2
@onready var red_bull_can_3: Sprite2D = $Cans/red_bull_can_3

func _update_health_label():
	$health_label.text =(str(GameState.player_health) + "/" + str(GameState.max_player_health) + " HP")

func _update_red_bull_icons():
	var red_bull_can_array = [red_bull_can, red_bull_can_2, red_bull_can_3]
	for can in red_bull_can_array:
		can.visible = false
	for x in range(GameState.red_bull_cans):
		red_bull_can_array[x].visible = true
