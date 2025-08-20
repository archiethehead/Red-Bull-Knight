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
var HEALTH = 100
var enemy_attackable = false
var enemy: Node = null
var dead = false


#Physics handler
func _physics_process(delta: float) -> void:
	var HEAD = $head_collider
	var TORSO = $torso_collider
	var colliding = test_move(global_transform, Vector2(0, -10))
	
	#Gravity logic
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("W") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#Attack input
	if Input.is_action_just_pressed("left_click") and is_on_floor():
		_perform_attack()
		
	#Movement logic
	var direction := Input.get_axis("A", "D")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
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
			await get_tree().create_timer(0.5).timeout
			HEAD.disabled = false
			TORSO.disabled = false
			ROLLING = false
		
	move_and_slide()
	$player_character_sprite._update_animation(velocity,is_on_floor(), CROUCHED, can_attack, ROLLING, dead)


#Combat handler
func _perform_attack():
	if can_attack:
		if enemy_attackable == true:
			enemy._die()
		can_attack = false
		$hitbox.monitoring = true
		$player_character_sprite._attack_animation(velocity, attack_2, CROUCHED)
		$hitbox.monitoring = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
		attack_2 = !attack_2

func _on_hitbox_body_entered(asset):
	if asset.is_in_group("enemy"):
		print("a")
		enemy = asset
		enemy_attackable = true

func _on_hitbox_body_exited(asset):
	if asset.is_in_group("enemy"):
		print("b")
		enemy = null
		enemy_attackable = false

func _die():
	dead = true
	$game_camera.position_smoothing_enabled = false
	$player_character_sprite.play("death_animation")
	await $player_character_sprite.animation_finished
	Engine.time_scale = 1
