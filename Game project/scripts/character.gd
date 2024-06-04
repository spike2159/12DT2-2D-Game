extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handles jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions
	# This is used for moving left or right and also plays the animation.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor() and not Input.is_action_just_pressed("ui_accept"):
			$AnimatedSprite2D.play("Run")
		$AnimatedSprite2D.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and not Input.is_action_just_pressed("ui_accept"):
			$AnimatedSprite2D.play("Idle")

	move_and_slide()
