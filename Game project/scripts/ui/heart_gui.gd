extends Panel  # Inherits from Panel, used for creating UI elements in Godot

@onready var sprite = $Heart_sprite  # References the heart sprite in the panel


func _update(full: bool):
	# Updates the sprite's frame based on the health status
	if full: 
		sprite.frame = 39  # Sets the sprite to the full heart frame
	else:
		sprite.frame = 54  # Sets the sprite to the empty heart frame
