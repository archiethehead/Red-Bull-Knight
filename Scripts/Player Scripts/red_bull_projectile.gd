extends CharacterBody2D

@export var speed = 300

var direction: float
var spawn_position: Vector2
var spawn_rotation: float

func _ready():
	global_position = spawn_position
	global_rotation = spawn_rotation
	velocity = Vector2.RIGHT.rotated(direction) * speed	

func _physics_process(delta):
	velocity.y += 500 * delta
		
	if velocity.x > 0:
		velocity.x = max(0, velocity.x - 100 * delta)
	elif velocity.x < 0:
		velocity.x = min(0, velocity.x + 100 * delta)
		
	if velocity.length() > 0:
		rotation = velocity.angle()
		
		move_and_slide()


func _on_redd_bull_area_body_entered(body):
	if body.is_in_group("enemy"):
		body._die()
