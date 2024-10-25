class_name MainMenu
extends Control

# References to UI elements in the main menu scene
@onready var play_button = $Menu_buttons/VBoxContainer/Play as Button  # Play button
@onready var info_button = $Menu_buttons/VBoxContainer/Info as Button  # Information button
@onready var quit_button = $Menu_buttons/VBoxContainer/Quit as Button  # Quit button
@onready var information = $Information as Info  # Information panel
@onready var menu_buttons = $Menu_buttons as NinePatchRect  # Container for menu buttons
@onready var title = $Title as NinePatchRect  # Game title display

@export var play_level = preload("res://scenes/level/level_1.tscn") as PackedScene  # Scene for the first level


func _ready() -> void:
	# Connect button signals to corresponding functions
	play_button.button_down.connect(on_play_pressed)  # Connects Play button
	info_button.button_down.connect(on_info_pressed)  # Connects Info button
	quit_button.button_down.connect(on_quit_pressed)  # Connects Quit button
	information.information_exited.connect(on_exit_info)  # Connects exit event for information panel


func on_play_pressed() -> void:
	# Switches to the play level scene
	get_tree().change_scene_to_packed(play_level)


func on_info_pressed() -> void:
	# Hides main menu buttons and title, then displays the information panel
	menu_buttons.visible = false
	title.visible = false
	information.visible = true
	information.set_process(true)  # Starts processing for the information panel


func on_exit_info():
	# Shows main menu buttons and title, then hides the information panel
	menu_buttons.visible = true
	title.visible = true
	information.visible = false


func on_quit_pressed() -> void:
	# Quits the game application
	get_tree().quit()
