extends CharacterBody2D

#Physics and AI variables
var SPEED = 120
var JUMP_VELOCITY = -400
var CROUCHED = false
var ROLLING = false
var DIRECTION = -1
var animation_speed =  1
var jumping = false

#Combat variables
var can_attack = true
var attack_2 = false
var chasing = false
var player = Node
var player_attackable = false
var previous_x = 0
var stuck_timer = 0.0
var dead = false
@onready var wall_detector = $enemy_character_sprite/wall_detector
@onready var floor_detector = $enemy_character_sprite/floor_detector


#Physics and AI handler
func _physics_process(delta: float) -> void:
	
	if not dead:
		#Gravity logic
		if not is_on_floor():
			velocity += get_gravity() * delta

		previous_x = global_position.x
		if stuck_timer > 0.2:
			velocity.y = JUMP_VELOCITY
			stuck_timer = 0.0 
		
		#Chase logic
		if chasing and can_attack:
			if abs(player.global_position.x - global_position.x) <= 50:
				velocity.x = 0
				await get_tree().create_timer(0.25).timeout
				if abs(player.global_position.x - global_position.x) <= 50 and not dead:
					_attack_player()
			else:
				if player.global_position > global_position:
					await get_tree().create_timer(0.1).timeout
					DIRECTION = 1
				else:
					await get_tree().create_timer(0.1).timeout
					DIRECTION = -1
				velocity.x = SPEED * DIRECTION
			
			if not dead and not floor_detector.is_colliding() and not jumping:
				SPEED = 150
				jumping = true
				velocity.y = JUMP_VELOCITY
				
			if is_on_floor() and jumping:
				SPEED = 120
				jumping = false
				
		#Patrol logic
		if not chasing and can_attack:
			velocity.x = SPEED * DIRECTION
			if wall_detector.is_colliding() or not floor_detector.is_colliding():
				DIRECTION *= -1
				_detector_reposition()
		move_and_slide()
		if not dead:
			$enemy_character_sprite._update_animation(velocity,is_on_floor(), CROUCHED, can_attack, ROLLING, animation_speed, dead) 

func _detector_reposition():
	if $enemy_character_sprite.flip_h == true:
		wall_detector.position.x = -12.0
		wall_detector.target_position.x = -24.0
		floor_detector.position.x = -20.0
	else:
		wall_detector.position.x = 4.0
		wall_detector.target_position.x = 24.0
		floor_detector.position.x = 12

#Combat handler
func _attack_player():
	if can_attack:
		if player_attackable and player.blocking == false:
			GameState._update_health(-1)
		can_attack = false
		if player.blocking == true:
			$sfx/block_sfx.play()
			player.blocking = false
			player.block_cooldown = true
		$enemy_character_sprite._attack_animation(velocity, attack_2, CROUCHED, dead)
		await get_tree().create_timer(0.45).timeout
		can_attack = true
		attack_2 = !attack_2

func _die():
	$sfx/death.play()
	dead = true
	velocity.x = 0
	velocity.y = 0
	$enemy_character_sprite._death_animation()
	$body_collider.set_deferred("disabled", true)
	$head_shape/head_collider.set_deferred("disabled", true)

func _on_player_detector_body_entered(body):
	if body.is_in_group("player"):
		player = body
		chasing = true


func _on_attack_collider_body_entered(body):
	if body.is_in_group("player"):
		player_attackable = true

func _on_attack_collider_body_exited(body):
	if body.is_in_group("player"):
		player_attackable = false


func _on_head_shape_body_entered(body):
	if body.is_in_group("player") and player.velocity.y >= 0:
		player.velocity.y = (JUMP_VELOCITY * 1.25)
		call_deferred("_die")
