extends Node2D


@onready var music = $AudioStreamPlayer2D
@onready var player = $CharacterBody2D

var dialog : bool = false

func _ready() -> void:
	var tween_music_start = get_tree().create_tween()
	tween_music_start.tween_property(music, "volume_db", -25.0, 4)
	
	await tween_music_start.finished


func _process(delta: float) -> void:
	if $Mobs.get_child_count() == 0 and not(dialog):
		dialog = true
		player.dialog_play = true
		Dialogic.start("timeline_level_4_win")
		Dialogic.timeline_ended.connect(on_dialogic_end_1)


func _on_start_dialog_body_entered(body: Node2D) -> void:
	$StartDialog.rotation_degrees = 90
	player.dialog_play = true
	Dialogic.start("timeline_demon_for_player")
	Dialogic.timeline_ended.connect(on_dialogic_end)


func on_dialogic_end():
	player.dialog_play = false

func on_dialogic_end_1():
	SaveManager.save_progress(4)
	var tween_music = get_tree().create_tween()
	tween_music.tween_property(music, "volume_db", -60, 2)
	PerehodScene.transition()
	
	await PerehodScene.on_transition_finished
	
	music.stop()
	get_tree().change_scene_to_file("res://Levels/Level_1.tscn")
