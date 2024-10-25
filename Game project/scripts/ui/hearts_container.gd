extends HBoxContainer  # Inherits from HBoxContainer, which arranges its children horizontally

@onready var heart_gui_class = preload("res://scenes/ui/heart_gui.tscn")  # Preloads the heart GUI scene for later instantiation


func _set_max_hearts(max: int):
	# Sets the maximum number of heart GUI instances based on the provided maximum
	for i in range(max):
		var heart = heart_gui_class.instantiate()  # Creates an instance of the heart GUI scene
		add_child(heart)  # Adds the heart instance to the HBoxContainer


func _update_hearts(current_health: int):
	# Updates the displayed hearts based on the current health
	var hearts = get_children()  # Retrieves all children (heart instances) of this container

	for i in range(current_health):
		hearts[i]._update(true)  # Updates hearts to the full state for current health

	for i in range(current_health, hearts.size()):
		hearts[i]._update(false)  # Updates remaining hearts to the empty state
