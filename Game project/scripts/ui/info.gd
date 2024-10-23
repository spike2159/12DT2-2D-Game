class_name Info
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_button as Button

signal exit_info

func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)


func on_exit_pressed() -> void:
	exit_info.emit()
	set_process(false)
