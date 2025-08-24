extends Node

class_name game_state

#Player variables
var player_health = 5
var max_player_health = 5
var player_character = null
var red_bull_cans = 0
var damage_screen_on = false

#Game variables
var game_UI = null
var pause_menu = null
var death_menu = null
var current_map = null
var next_map = null
var damage_screen = null

#Checkpoint variables
var checkpoint = null
var enemies_killed = []
var reloading = false
	
func _update_health(health):
	
	if health < 0 and not damage_screen_on:
		damage_screen_on = true
		damage_screen._flash()
	
	player_health += health
	if player_health > max_player_health:
		player_health -= (player_health - max_player_health)
	if player_health <= 0:
		player_character._die()
	game_UI._update_health_label()

func _update_red_bull(redbull):
	red_bull_cans += redbull
	if red_bull_cans > 3:
		red_bull_cans = 3
	if red_bull_cans < 0:
		red_bull_cans = 0
	game_UI._update_red_bull_icons()

func _checkpoint(check):
	checkpoint = check.global_position
	var enemies_killed_temp = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies_killed_temp:
		if enemy is CharacterBody2D:
			if enemy.dead == true:
				enemies_killed.append(enemy.name)

func _reload_level():
	reloading = true
	get_tree().reload_current_scene()
		
func _pause():
	get_tree().paused = true
	pause_menu._switch_state()

func _unpause():
	get_tree().paused = false
	pause_menu._switch_state()

func _level_finished():
	get_tree().change_scene_to_file(next_map)
