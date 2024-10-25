extends CharacterBody2D

var speed = -20.0  # Movement speed of the character (negative indicates initial leftward movement)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")  # Gravity value from project settings

var facing_right = false  # Tracks direction the character is facing
@export var hiding = false  # Indicates if the character is hiding
@export var unhide_finished = true  # Indicates if the unhide animation has finished
var player_detected = false  # Tracks if the player has been detected
var dead = false  # Indicates if the character is dead


func _ready():
	# Plays the walking animation when the character is ready
	$Snail_animation.play("walk")


func _physics_process(delta):
	# Applies gravity to the character when not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta

	# Flips direction if the character is at the edge and on the floor
	if not $Edge_detector.is_colliding() and is_on_floor():
		flip()
	# Flips direction if a wall is detected, the player isn't detected, and the character is on the floor
	if $Wall_detector.is_colliding() and not player_detected and is_on_floor():
		flip()

	# Moves the character only if not hiding or dead
	if not hiding and not dead:
		velocity.x = speed
	else:
		velocity.x = 0  # Stops movement if hiding or dead

	# Executes movement and sliding
	move_and_slide()


func flip():
	# Flips the direction the character is facing and adjusts the speed accordingly
	facing_right = not facing_right
	scale.x = abs(scale.x) * -1  # Flips the sprite horizontally
	if facing_right:
		speed = abs(speed)  # Moves right
	else:
		speed = abs(speed) * -1  # Moves left


func _on_hit_detection_area_entered(area):
	# Handles death if hit by an area with a "sword" meta
	if area.has_meta("sword") and not hiding:
		dead = true
		$Snail_animation.play("die")  # Plays death animation
		await $Snail_animation.animation_finished  # Waits until the death animation is complete
		queue_free()  # Removes character from the scene


func _on_player_detection_area_entered(area):
	# Starts hiding if the player enters the detection area
	if area.has_meta("player"):
		player_detected = true
		if not hiding:
			$Snail_animation.play("hide")  # Plays hide animation
			await $Snail_animation.animation_finished


func _on_player_detection_area_exited(area):
	# Starts the unhide process if the player leaves the detection area
	if area.has_meta("player"):
		player_detected = false
		await get_tree().create_timer(2).timeout  # Waits for 2 seconds before checking player presence
		if not player_detected:
			$Snail_animation.play("unhide")  # Plays unhide animation
			await $Snail_animation.animation_finished
			if unhide_finished and not player_detected:
				$Snail_animation.play("walk")  # Returns to walking animation if unhide is finished and player is absent
			else:
				$Snail_animation.play("hide")  # Re-hides if player re-enters area during unhide
				await $Snail_animation.animation_finished
