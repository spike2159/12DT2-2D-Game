extends Control

@onready var respwan_button = $Menu_buttons/VBoxContainer/Respwan as Button
@onready var return_button = $Menu_buttons/VBoxContainer/Return as Button


func _ready() -> void:
	respwan_button.button_down.connect(on_respwan_pressed)
	return_button.button_down.connect(on_return_pressed)


func on_respwan_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level_1.tscn")


func on_return_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
