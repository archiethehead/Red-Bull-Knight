extends Node

class_name game_state
@onready var player_character: CharacterBody2D = $player_character
	
#Player variables
var player_health = 5
var max_player_health = 5

	
func _update_health(health):
	player_health += health
	$game_state_UI/health_label.text = (str(player_health) + "/" + str(max_player_health) + " Hp")
	if player_health <= 0:
		player_character._die()

func _ready():
	$game_state_UI/health_label.text = (str(player_health) + "/" + str(max_player_health) + " Hp")
