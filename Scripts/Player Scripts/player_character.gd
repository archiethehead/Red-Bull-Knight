extends CharacterBody2D


#Physics variables
var SPEED = 150
var CROUCHED = false
var ROLLING = false
var JUMP_VELOCITY = -400

#Combat variables
var attack_damage = 10
var attack_cooldown = 0.25
var can_attack = true
var attack_2 = false
var enemies_attackable = []
var dead = false
var blocking = false
var block_cooldown = false

#Physics handler
func _physics_process(delta: float) -> void:

	#Variables
	var HEAD = $head_collider
	var TORSO = $torso_collider
	var colliding = test_move(global_transform, Vector2(0, -10))
	
	#Gravity logic
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("W") and is_on_floor():
		if not blocking:
			velocity.y = JUMP_VELOCITY
		
	#Attack input
	if Input.is_action_just_pressed("left_click") and is_on_floor():
		$player_character_sprite._attack_animation(velocity, attack_2, CROUCHED)
		_perform_attack()
	
	#Block logic
	if Input.is_action_just_pressed("right_click") and is_on_floor() and can_attack and not CROUCHED:
		if not block_cooldown:
			velocity.x = 0
			blocking = true
		else:
			await get_tree().create_timer(attack_cooldown).timeout
			if Input.is_action_pressed("right_click") and is_on_floor() and can_attack:
				velocity.x = 0
				blocking = true
				block_cooldown = false
	if Input.is_action_just_released("right_click"):
		blocking = false
		
	#Movement logic
	var direction := Input.get_axis("A", "D")
	if not blocking:
		velocity.x = direction * SPEED
	
	#Crouch logic
	if Input.is_action_pressed("S") and is_on_floor():
		CROUCHED = true
		SPEED = 75
		HEAD.disabled = true
		
	elif colliding == false:
		HEAD.disabled = false
		SPEED = 150
		CROUCHED = false
	
	#Roll logic
	if Input.is_action_just_pressed("SPACE"):
		if velocity.x != 0 and is_on_floor():
			HEAD.disabled = true
			TORSO.disabled = true
			ROLLING = true
			await get_tree().create_timer(0.55).timeout
			HEAD.disabled = false
			TORSO.disabled = false
			ROLLING = false
		
	move_and_slide()
	if not dead and not blocking:
		$player_character_sprite._update_animation(velocity,is_on_floor(),
		 CROUCHED, can_attack, ROLLING, dead)
	elif blocking:
		$player_character_sprite._block_animation()

#Combat handler
func _perform_attack():
	if can_attack:
		if not enemies_attackable.is_empty():
			for enemy in enemies_attackable:
				enemy._die()
		can_attack = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
		attack_2 = !attack_2

func _die():
	if not dead:
		Engine.time_scale = 0.2
		dead = true
		$game_camera.position_smoothing_enabled = false
		$player_character_sprite.play("death_animation")
		await $player_character_sprite.animation_finished
		Engine.time_scale = 1
		get_tree().reload_current_scene()


func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		enemies_attackable.append(body)

func _on_hitbox_body_exited(body):
	if body.is_in_group("enemy"):
		enemies_attackable.erase(body)
