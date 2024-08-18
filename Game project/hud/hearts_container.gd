extends HBoxContainer

@onready var heart_gui_class = preload("res://hud/heart_gui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_max_hearts(max: int):
	for i in range(max):
		var heart = heart_gui_class.instantiate()
		add_child(heart)

func _update_hearts(current_health: int):
	var hearts = get_children()

	for i in range(current_health):
		hearts[i]._update(true)

	for i in range(current_health, hearts.size()):
		hearts[i]._update(false)
