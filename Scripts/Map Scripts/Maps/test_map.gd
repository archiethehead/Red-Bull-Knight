extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Game state variable assignment
	GameState.player_character = $player_character
	GameState.game_UI = $game_state_UI
	GameState.pause_menu = $pause_menu
	
	if not GameState.reloading:
		GameState.checkpoint = $player_character.global_position
		
	#Level preparations
	$game_state_UI._update_health_label()
	
	GameState._update_health(GameState.max_player_health)
	
	if GameState.reloading:
		$player_character.global_position = GameState.checkpoint
		$player_character.global_position.y -= 50
		
		#Kill enemies on reload
		if len(GameState.enemies_killed) > 0:
			var enemies_in_scene = []
			var enemies = get_tree().get_nodes_in_group("enemy")
			
			for enemy in enemies:
				if enemy is CharacterBody2D:
					enemies_in_scene.append(enemy)
			
			for enemy in enemies_in_scene:
				for dead in GameState.enemies_killed:
					if enemy.name == dead:
						enemy._die()
