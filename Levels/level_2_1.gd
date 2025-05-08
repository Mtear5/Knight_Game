extends Node2D

@onready var music = $AudioStreamPlayer2D
@onready var anim_f = $F/f_animation
@onready var object_f = $F

var door_ch : bool = false # Детектор для нахождение в области двери


func _ready() -> void:
	anim_f.play("f_animate")
	
	var tween_music_start = get_tree().create_tween()
	tween_music_start.tween_property(music, "volume_db", -20.0, 4)
	await tween_music_start.finished


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact_f") and door_ch:
		var tween_music_end = get_tree().create_tween()
		tween_music_end.tween_property(music, "volume_db", -40.0, 2)
		PerehodScene.transition()
		
		await PerehodScene.on_transition_finished
		
		music.stop()
		get_tree().change_scene_to_file("res://Levels/Level_2_2.tscn")	


func _on_door_in_level_2_2_body_entered(body: Node2D) -> void:
	door_ch = true
	object_f.visible = true

func _on_door_in_level_2_2_body_exited(body: Node2D) -> void:
	door_ch = false
	object_f.visible = false
