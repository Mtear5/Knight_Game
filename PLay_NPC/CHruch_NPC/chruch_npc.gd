extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var player = $"../CharacterBody2D"
@onready var music_level = $"../AudioStreamPlayer2D"

func _ready() -> void:
	anim.play("Idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	player.dialog_play = true
	if SaveManager.last_completed_level == 1:
		Dialogic.start("timeline_1")
		Dialogic.timeline_ended.connect(on_dialogic_end)
	elif SaveManager.last_completed_level == 2:
		Dialogic.start("timeline_2")
		Dialogic.timeline_ended.connect(on_dialogic_end)
	elif SaveManager.last_completed_level == 3:
		Dialogic.start("timeline_3")
		Dialogic.timeline_ended.connect(on_dialogic_end)


func on_dialogic_end():
	var tween_music_level_end = get_tree().create_tween()
	tween_music_level_end.tween_property(music_level, "volume_db", -40.0, 2)
	PerehodScene.transition()
		
	await PerehodScene.on_transition_finished
	
	music_level.stop()
	if SaveManager.last_completed_level == 1:
		get_tree().change_scene_to_file("res://Levels/Level_2.tscn")
	elif SaveManager.last_completed_level == 2:
		get_tree().change_scene_to_file("res://Levels/Level_3.tscn")
	elif SaveManager.last_completed_level == 3:
		get_tree().change_scene_to_file("res://Levels/Level_4_1.tscn")
