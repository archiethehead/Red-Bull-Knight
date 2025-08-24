extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Game state variable assignment
	GameState.player_character = $player_character
	GameState.game_UI = $game_state_UI
	GameState.pause_menu = $pause_menu
	GameState.current_map = self
	GameState.next_map = "res://Scenes/Game Scenes/main_menu.tscn"
	GameState.death_menu = $death_menu
	GameState.damage_screen = $jesus
	
	if not GameState.reloading:
		GameState.checkpoint = $player_character.global_position
		
	#Level preparations
	$game_state_UI._update_health_label()
	
	GameState._update_health(GameState.max_player_health)
	
	if GameState.reloading:
		$player_character.global_position = GameState.checkpoint
		$player_character.global_position.y -= 50
		$player_character/game_camera.global_position = GameState.checkpoint
		$player_character/game_camera.global_position.y -= 40
		
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
