extends CharacterBody2D

#Physics and AI variables
var SPEED = 150
var JUMP_VELOCITY = -400
var CROUCHED = false
var ROLLING = false
var DIRECTION = -1
var animation_speed =  1

#Combat variables
var can_attack = true
var chasing = false
var player = Node
var previous_x = 0
var stuck_timer = 0.0
var dead = false
@onready var wall_detector = $enemy_character_sprite/wall_detector
@onready var floor_detector = $enemy_character_sprite/floor_detector


#Physics and AI handler
func _physics_process(delta: float) -> void:
	if dead == false:
		#Gravity logic
		if not is_on_floor():
			velocity += get_gravity() * delta
		
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
		pass
		
		#Chase and patrol logic
		if chasing == true:
			pass
		else:
			velocity.x = SPEED * DIRECTION
			if wall_detector.is_colliding() or not floor_detector.is_colliding():
				DIRECTION *= -1
				_detector_reposition()
		move_and_slide()
		$enemy_character_sprite._update_animation(velocity,is_on_floor(), CROUCHED, can_attack, ROLLING, animation_speed) 

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
func _ready():
	pass

func _die():
	dead = true
	$head_collider.disabled = true
	$torso_collider.disabled = true
	$feet_collider.disabled = true
	$enemy_character_sprite._death_animation()
