class_name Info  # Defines this script as the Info class, making it reusable in other scripts
extends Control  # Inherits from Control, the base class for all UI elements

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_button as Button  # References the exit button in the UI

signal information_exited  # Signal emitted when the information is exited


func _ready():
	# Connects the exit button's button_down signal to the on_exit_pressed function
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)  # Disables the process function by default


func on_exit_pressed() -> void:
	# Emits the information_exited signal when the exit button is pressed
	information_exited.emit()
	set_process(false)  # Ensures processing is disabled upon exit
