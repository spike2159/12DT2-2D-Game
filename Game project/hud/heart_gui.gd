extends Panel

@onready var sprite = $Sprite2D
@onready var spritee = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _update(heart_status: bool):
	if heart_status: 
		sprite.frame = 39
	else:
		sprite.frame = 54
