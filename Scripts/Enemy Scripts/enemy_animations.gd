extends AnimatedSprite2D


#Variables
@onready var wall_detector = $wall_detector
@onready var floor_detector = $floor_detector

@onready var walking_sfx: AudioStreamPlayer2D = $"../sfx/walking_sfx"
@onready var sword_sfx: AudioStreamPlayer2D = $"../sfx/sword_sfx"


func _update_animation(vel, grounded, crouched, attack, roll, animation_speed, dead):
	speed_scale = animation_speed
	var run = "run_animation"
	var idle = "idle_animation"
	if not dead:
		#Crouch animation
		if attack == true:
			if crouched == true:
				run = "crouch_walk_animation"
				idle = "crouch_idle_animation"
		
		#Run animation
		if vel.x != 0:
			flip_h = vel.x < 0
			if flip_h == true:
				offset.x = -10.0
			else:
				offset.x = 0
			if attack == true:
				if roll == false:
					play(run)
					if walking_sfx.is_playing() == false:
						walking_sfx.play()
				elif roll == true:
					play(" roll_animation")
					await animation_finished
		else:
			if attack == true:
				if walking_sfx.is_playing():
					walking_sfx.stop()
				play(idle)
		
		#Jump/Fall animation
		if not grounded:
			if walking_sfx.is_playing():
				walking_sfx.stop()
			if vel.y < 0:
				play("jump_animation")
			elif vel.y > 0:
				play("fall_animation")
	else:
		_death_animation()

#Attack animation
func _attack_animation(vel, attack_an, crouched, dead):
	if not dead:
		sword_sfx.play()
		if crouched == true:
			play("attack_animation_crouched")
		else:
			if vel.x != 0:
				if attack_an == false:
					play("attack_animation_walk")
				else:
					play("attack_animation_walk_2")
			else:
				if attack_an == false:
					play("attack_animation")
				else:
					play("attack_animation_2")
		

func _death_animation():
	walking_sfx.stop()
	play("death_animation")
