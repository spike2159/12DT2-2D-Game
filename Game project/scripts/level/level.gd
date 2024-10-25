extends Node2D  # Inherits from Node2D, a basic node for 2D games

@onready var hearts_container = $Ui/Hearts_container  # References the UI container for heart icons
@onready var player = $Player  # References the player node


func _ready():
	# Sets the maximum number of hearts based on the player's maximum health
	hearts_container._set_max_hearts(player.max_health)
	# Updates the heart display to reflect the player's current health
	hearts_container._update_hearts(player.current_health)
	# Connects the player's health_changed signal to update the hearts display whenever health changes
	player.health_changed.connect(hearts_container._update_hearts)
