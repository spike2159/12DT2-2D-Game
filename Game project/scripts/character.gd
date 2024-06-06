extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_falling = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handles jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.y == 0 and is_on_floor():
		if velocity.x == 0:
			$AnimatedSprite2D.play("idle")
		if velocity.x < -1 or velocity.x > 1:
			$AnimatedSprite2D.play("run")
	elif velocity.y > 0:
		$AnimatedSprite2D.play("fall")
	else:
		$AnimatedSprite2D.play("jump")

	move_and_slide()
