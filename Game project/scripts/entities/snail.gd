extends CharacterBody2D


var speed = -20.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false
@export var hiding = false
@export var unhide_finished = true
var player_detected = false

func _ready():
	$Snail_animation.play("walk")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if !$Edge_detector.is_colliding() and is_on_floor():
		flip()
	if $Wall_detector.is_colliding() and!player_detected and is_on_floor():
		flip()

	if !hiding:
		velocity.x = speed
	elif hiding:
		velocity.x = 0
		

	move_and_slide()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

func _on_hit_detection_area_entered(area):
	if area.has_meta("sword") and !hiding:
		$Snail_animation.play("die")
		await $Snail_animation.animation_finished
		queue_free()


func _on_player_detection_area_entered(area):
	if area.has_meta("player"):
		player_detected = true
		if !hiding:
			$Snail_animation.play("hide")
			await $Snail_animation.animation_finished


func _on_player_detection_area_exited(area):
	if area.has_meta("player"):
		player_detected = false
		await get_tree().create_timer(2).timeout
		if !player_detected:
			$Snail_animation.play("unhide")
			await $Snail_animation.animation_finished
			if unhide_finished and !player_detected:
				$Snail_animation.play("walk")
			else:
				$Snail_animation.play("hide")
				await $Snail_animation.animation_finished
