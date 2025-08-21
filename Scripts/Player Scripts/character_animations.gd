extends AnimatedSprite2D

#Animation handler
func _update_animation(vel, grounded, crouched, attack, roll, dead):
	var run = "run_animation"
	var idle = "idle_animation"
	
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
			elif roll == true:
				play(" roll_animation")
				await animation_finished
	else:
		if attack == true and not dead:
			play(idle)
	
	#Jump/Fall animation
	if not grounded and not dead:
		if vel.y < 0:
			play("jump_animation")
		elif vel.y > 0:
			play("fall_animation")

#Attack animation
func _attack_animation(vel, attack_an, crouched):
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
	await animation_finished
