extends Node2D

@onready var hearts_container = $Ui/Hearts_container
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	hearts_container._set_max_hearts(player.max_health)
	hearts_container._update_hearts(player.current_health)
	player.health_changed.connect(hearts_container._update_hearts)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
