extends CharacterBody2D

signal health_changed

@export var speed = 300.0
@export var jump_velocity = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var crouch_raycast1 = $Crouch_raycast1
@onready var crouch_raycast2 = $Crouch_raycast2

@export var max_health = 3
@onready var current_health: int = max_health
var can_take_damage = true
@export var hit = false
var in_damage_area = false

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
	if Input.is_action_just_pressed("jump") and is_on_floor() and !attacking:
		if is_crouching:
			velocity.y = jump_velocity * 0.75
		else:
			velocity.y = jump_velocity
	elif Input.is_action_just_pressed("jump") and double_jump and !attacking:
		if is_crouching:
			velocity.y = jump_velocity * 0.75
		else:
			velocity.y = jump_velocity 
		double_jump = false

	if is_on_floor() and has_jumped:
		has_jumped = false

	if is_on_floor() and !double_jump:
		double_jump = true

	if Input.is_action_just_pressed("crouch") and is_on_floor():
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
		$Animatedsprite.scale.x = direction  
		if is_crouching and not attacking:
			velocity.x = direction * speed * 0.75
		elif attacking:
			velocity.x = 0
		else:
			velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_crouching and !hit:
		attacking = true
		$Animation_player.play("attack_1")

	if $Animation_player.current_animation != "attack_1":
		attacking = false


	if velocity.y == 0 and is_on_floor() and not attacking: 
		if velocity.x == 0:
			if is_crouching == true:
				if hit:
					$Animation_player.play("hit_crouch")
				else:
					$Animation_player.play("crouch")
			else:
				if hit:
					$Animation_player.play("hit_idle")
				else:
					$Animation_player.play("idle")
		if velocity.x != 0:
			if is_crouching == true:
				if hit:
					$Animation_player.play("hit_crouch")
				else:
					$Animation_player.play("crouch_walk")
			else:
				if hit:
					$Animation_player.play("hit_run")
				else:
					$Animation_player.play("run")
	elif velocity.y > 0 and not attacking and not is_crouching:
		$Animation_player.play("fall")
	elif has_jumped and Input.is_action_just_pressed("jump") and not attacking and not is_crouching:
		$Animation_player.play("somersault")
	elif not has_jumped and not attacking and not is_crouching:
		$Animation_player.play("jump")

	if can_take_damage and in_damage_area:
		take_damage()

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

func _on_hit_detection_area_entered(area):
	if area.has_meta("damage"):
		in_damage_area = true

func _on_hit_detection_area_exited(area):
	if area.has_meta("damage"):
		in_damage_area = false

func take_damage():
	hit = true
	iframes()
	current_health -= 1
	if current_health <= 0:
		die()
	health_changed.emit(current_health)

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true

func die():
	get_tree().reload_current_scene()
