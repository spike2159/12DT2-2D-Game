extends CharacterBody2D

signal health_changed  # Signal to notify when the player's health changes

@export var play_level = preload("res://scenes/ui/death_screen.tscn") as PackedScene  # Scene for death screen
@export var speed = 300.0  # Player's movement speed
@export var jump_velocity = -400.0  # Initial velocity for player jump

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")  # Gravity setting from project

@onready var crouch_raycast1 = $Crouch_raycast1  # Raycast to check crouch collisions
@onready var crouch_raycast2 = $Crouch_raycast2  # Second raycast to check crouch collisions

@export var max_health = 3  # Maximum health for player
@onready var current_health = max_health  # Initializes player's health
var can_take_damage = true  # Indicates if player can take damage
@export var hit = false  # Tracks if the player has been hit
var in_damage_area = false  # Tracks if the player is in an area with potential damage

var double_jump = false  # Tracks if player can perform a double jump
var has_jumped = true  # Tracks if the player has jumped
var is_crouching = false  # Indicates if the player is crouching
var attacking = false  # Tracks if player is attacking
var stuck_under_object = false  # Tracks if the player is stuck under an object


func _physics_process(delta):
	# Applies gravity to the player when they are not on the floor and updates jump state
	if not is_on_floor():
		velocity.y += gravity * delta
		has_jumped = true

	# Handles the jump input when player is on the floor and not attacking
	if Input.is_action_just_pressed("jump") and is_on_floor() and not attacking:
		# Reduced jump velocity if player is crouching
		if is_crouching:
			velocity.y = jump_velocity * 0.75
		else:
			velocity.y = jump_velocity

	# Handles double jump
	elif Input.is_action_just_pressed("jump") and double_jump and not attacking:
		# Reduced jump velocity if player is crouching
		if is_crouching:
			velocity.y = jump_velocity * 0.75
		else:
			velocity.y = jump_velocity 
		double_jump = false

	# Reset jump and double jump states based on floor contact
	if is_on_floor() and has_jumped:
		has_jumped = false
	if is_on_floor() and not double_jump:
		double_jump = true

	# Handles crouch input and checks if player is stuck under an object
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

	# Handles player movement direction and updates animation state
	var direction = Input.get_axis("left", "right")
	if direction:
		$Animatedsprite.scale.x = direction  # Flip player sprite based on direction
		# Adjust movement speed based on crouching and attacking states
		if is_crouching and not attacking:
			velocity.x = direction * speed * 0.75
		elif attacking:
			velocity.x = 0
		else:
			velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)  # Slow down to a stop if no direction

	# Initiates attack animation if player is on the floor and not crouching or hit
	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_crouching and not hit:
		attacking = true
		$Animation_player.play("attack_1")

	# Reset attacking state when attack animation ends
	if $Animation_player.current_animation != "attack_1":
		attacking = false

	# Manages idle, run, crouch, jump, and fall animations based on player's movement
	if velocity.y == 0 and is_on_floor() and not attacking: 
		if velocity.x == 0:
			if is_crouching:
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
			if is_crouching:
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

	# Call to handle damage if player is in a damage area and can take damage
	if can_take_damage and in_damage_area:
		take_damage()

	# Executes player movement
	move_and_slide()


func crouch():
	# Sets crouching state if player is not already crouching
	if is_crouching:
		return
	is_crouching = true


func stand():
	# Sets standing state if player is crouching
	if not is_crouching:
		return
	is_crouching = false


func not_under_object() -> bool:
	# Checks if no objects are above player using raycasts
	var result = not crouch_raycast1.is_colliding() and not crouch_raycast2.is_colliding()
	return result


func _on_hit_detection_area_entered(area):
	# Marks player as in a damage area if area has "damage" metadata
	if area.has_meta("damage"):
		in_damage_area = true


func _on_hit_detection_area_exited(area):
	# Marks player as out of a damage area if area has "damage" metadata
	if area.has_meta("damage"):
		in_damage_area = false


func take_damage():
	# Applies damage to player and reduces health
	hit = true
	iframes()  # Enables temporary invincibility
	current_health -= 1
	if current_health == 0:
		die()  # Triggers death if health reaches zero
	health_changed.emit(current_health)  # Emits signal with updated health


func iframes():
	# Sets a brief period where player cannot take damage
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true


func die():
	# Loads death screen when player dies
	get_tree().change_scene_to_file("res://scenes/ui/death_screen.tscn")
