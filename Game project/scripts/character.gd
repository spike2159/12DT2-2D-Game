extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var crouch_raycast1 = $Crouch_raycast1
@onready var crouch_raycast2 = $Crouch_raycast2

var double_jump = false
var has_jumped = true
var is_crouching = false
var attacking = false
var stuck_under_object = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		has_jumped = true

	# Handles jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not attacking:
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and double_jump and not attacking:
		velocity.y = JUMP_VELOCITY
		double_jump = false

	if is_on_floor() and has_jumped:
		has_jumped = false

	if is_on_floor() and not double_jump:
		double_jump = true

	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		if not_under_object():
			stand()
		else:
			stuck_under_object = true

	if stuck_under_object and not_under_object():
		stand()
		stuck_under_object = false

	var direction = Input.get_axis("left", "right")
	if direction:
		$AnimatedSprite2D.scale.x = direction  
		if is_crouching and not attacking:
			velocity.x = direction * SPEED * 0.5
		elif attacking:
			velocity.x = 0
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_crouching:
		attacking = true
		$AnimationPlayer.play("attack_1")

	if $AnimationPlayer.current_animation != "attack_1":
		attacking = false

	if velocity.y == 0 and is_on_floor() and not attacking: 
		if velocity.x == 0:
			if is_crouching:
				$AnimationPlayer.play("crouch")
			else:
				$AnimationPlayer.play("idle")
		if velocity.x < -1 or velocity.x > 1:
			if is_crouching:
				$AnimationPlayer.play("crouch_walk")
			else:
				$AnimationPlayer.play("run")
	elif velocity.y > 0 and not attacking and not is_crouching:
		$AnimationPlayer.play("fall")
	elif has_jumped and Input.is_action_just_pressed("jump") and not attacking and not is_crouching:
		$AnimationPlayer.play("somersault")
	elif not has_jumped and not attacking and not is_crouching:
		$AnimationPlayer.play("jump")
		
	move_and_slide()

func crouch():
	if is_crouching:
		return
	is_crouching = true

func stand():
	if !is_crouching:
		return
	is_crouching = false

func not_under_object() -> bool:
	var result = !crouch_raycast1.is_colliding() and !crouch_raycast2.is_colliding()
	return result

func _on_sword_area_2d_area_entered(area):
	if area.has_meta("testdummy"):
		area.queue_free()
