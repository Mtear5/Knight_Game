extends Node2D

@onready var label = $CharacterBody2D/Label
@onready var music = $AudioStreamPlayer2D
@onready var player = $CharacterBody2D

var glass_preload = preload("res://PLay_mobs/Mobs_level_3/glass.tscn")
var dialog_on = false

func _ready() -> void:
	var glass_1 = glass_preload.instantiate()
	var glass_2 = glass_preload.instantiate()
	var glass_3 = glass_preload.instantiate()
	var glass_4 = glass_preload.instantiate()
	var glass_5 = glass_preload.instantiate()
	var glass_6 = glass_preload.instantiate()
	
	glass_1.position = Vector2(654, 528)
	glass_2.position = Vector2(307, 528)
	glass_3.position = Vector2(524, 369)
	glass_4.position = Vector2(486, 177)
	glass_5.position = Vector2(1003, 497)
	glass_6.position = Vector2(2119, 527)
	
	$Mobs.add_child(glass_1)
	$Mobs.add_child(glass_2)
	$Mobs.add_child(glass_3)
	$Mobs.add_child(glass_4)
	$Mobs.add_child(glass_5)
	$Mobs.add_child(glass_6)
	
	var tween_label_start = get_tree().create_tween()
	var tween_music_start = get_tree().create_tween()
	tween_music_start.tween_property(music, "volume_db", -30.0, 4)
	tween_label_start.tween_property(label, "modulate:a", 1.0, 2)
	await tween_label_start.finished
	
	
	var tween_label_end = get_tree().create_tween()
	tween_label_end.tween_property(label, "modulate:a", 0.0, 2)
	await tween_label_end.finished
	
	label.visible = false

func _process(delta: float) -> void:
	if $Mobs.get_child_count() == 0 and not(dialog_on):
		dialog_on = true
		player.dialog_play = true
		Dialogic.start("timeline_level_3_win")
		Dialogic.timeline_ended.connect(on_dialogic_end)


func on_dialogic_end():
	SaveManager.save_progress(3)
	var tween_music = get_tree().create_tween()
	tween_music.tween_property(music, "volume_db", -60, 2)
	PerehodScene.transition()
	
	await PerehodScene.on_transition_finished
	
	music.stop()
	get_tree().change_scene_to_file("res://Levels/Level_1.tscn")

func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", 110)
