class_name MainMenu
extends Control


@onready var play_button = $Menu_buttons/VBoxContainer/Play as Button
@onready var info_button = $Menu_buttons/VBoxContainer/Info as Button
@onready var quit_button = $Menu_buttons/VBoxContainer/Quit as Button
@onready var information = $Information as Info
@onready var menu_buttons = $Menu_buttons as NinePatchRect
@onready var title = $Title as NinePatchRect

@export var play_level = preload("res://scenes/level/level_1.tscn") as PackedScene

func _ready() -> void:
	play_button.button_down.connect(on_play_pressed)
	info_button.button_down.connect(on_info_pressed)
	quit_button.button_down.connect(on_quit_pressed)
	information.exit_info.connect(on_exit_info)

func on_play_pressed() -> void:
	get_tree().change_scene_to_packed(play_level)

func on_info_pressed() -> void:
	menu_buttons.visible = false
	title.visible = false
	information.visible = true
	information.set_process(true)

func on_exit_info():
	menu_buttons.visible = true
	title.visible = true
	information.visible = false

func on_quit_pressed() -> void:
	get_tree().quit()
