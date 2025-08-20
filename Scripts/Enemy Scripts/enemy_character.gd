extends CharacterBody2D

#Physics and AI variables
var SPEED = 150
var JUMP_VELOCITY = -400
var PATROL_DISTANCE = 20
var CROUCHED = false
var ROLLING = false
var DIRECTION = -1
var START_POSITION: Vector2
var left_bound: float
var right_bound: float
var animation_speed =  1

#Combat variables
var chase_speed =  120
var can_attack = true
var chasing = false
var player = Node
var previous_x = 0
var stuck_timer = 0.0
var dead = false

#Physics and AI handler
func _physics_process(delta: float) -> void:
	if dead == false:
		#Gravity logic
		if not is_on_floor():
			velocity += get_gravity() * delta
		velocity.x = DIRECTION * SPEED
		
		#Stuck logic
		if abs(global_position.x - previous_x) < 1.0 and is_on_floor():
			stuck_timer += delta
		else:
			stuck_timer = 0.0	

		previous_x = global_position.x
		if stuck_timer > 0.2:
			velocity.y = JUMP_VELOCITY
			stuck_timer = 0.0 
		
		#Detection logic
		$player_detector.target_position = Vector2(100 * DIRECTION, 0)
		$player_detector/angled_player_detector.target_position = Vector2(100 * DIRECTION, -100)
		if $player_detector.is_colliding():
			var asset = $player_detector.get_collider()
			if asset.is_in_group("player"):
				player = asset
				chasing = true
			else:
				player = null
				chasing = false
				
		move_and_slide()
		$enemy_character_sprite._update_animation(velocity,is_on_floor(), CROUCHED, can_attack, ROLLING, animation_speed) 

#Combat handler
func _ready():
	#var path_follow = get_node()
	START_POSITION = global_position
	left_bound = global_position.x - PATROL_DISTANCE
	right_bound = global_position.x + PATROL_DISTANCE

func _die():
	dead = true
	$head_collider.disabled = true
	$torso_collider.disabled = true
	$feet_collider.disabled = true
	$enemy_character_sprite._death_animation()
