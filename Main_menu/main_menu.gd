extends Node2D

@onready var music = $Pixel11
@onready var music_button = $Retro11
@onready var music_button_click = $Retro12
@onready var light = $DirectionalLight2D
@onready var play_button = $Play
@onready var quit_button = $Quit

var work_menu: bool = false


func _ready() -> void:
	light.enabled = true
	
	var tween_scen = get_tree().create_tween()
	var tween_music = get_tree().create_tween()
	tween_scen.tween_property(light, "energy", 0.2, 4)
	tween_music.tween_property(music, "volume_db", -20.0, 4)

	await tween_scen.finished
	
	var tween_play_button = get_tree().create_tween()
	var tween_quit_button = get_tree().create_tween()
	tween_play_button.tween_property(play_button, "modulate:a", 0.8, 2)
	tween_quit_button.tween_property(quit_button, "modulate:a", 0.8, 2)
	
	await tween_quit_button.finished
	
	work_menu = true


func _on_button_pressed() -> void:
	if work_menu:
		work_menu = false
		if not music_button_click.playing:
			music_button_click.play()
		
		var tween_play_button = get_tree().create_tween()
		var tween_quit_button = get_tree().create_tween()
		tween_play_button.tween_property(play_button, "modulate:a", 0, 0.5)
		tween_quit_button.tween_property(quit_button, "modulate:a", 0, 0.5)
		
		await tween_quit_button.finished
		
		var tween_scen = get_tree().create_tween()
		var tween_music = get_tree().create_tween()
		tween_scen.tween_property(light, "energy", 1.0, 1)
		tween_music.tween_property(music, "volume_db", -50, 2)
		
		await tween_music.finished
		
		music.stop()
		get_tree().change_scene_to_file("res://Levels/Level_1.tscn")


func _on_quit_pressed() -> void:
	if work_menu:
		music.stop()
		get_tree().quit()


func _on_play_mouse_entered() -> void:
	if work_menu:
		music_button.play()


func _on_quit_mouse_entered() -> void:
	if work_menu:
		music_button.play()
