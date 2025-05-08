extends Node

@onready var pause_menu = $"../CanvasLayer/PauseMenu"

var pause_on : bool = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel")  and !pause_on:
		pause_on = !pause_on
	
	if pause_on:
		get_tree().paused = true
		pause_menu.visible = true
	elif !pause_on:
		get_tree().paused = false
		pause_menu.visible = false


func _on_button_pressed() -> void:
	pause_on = !pause_on


func _on_button_2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Main_menu/main_menu.tscn")
