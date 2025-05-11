extends Node2D


@onready var music = $AudioStreamPlayer2D
@onready var anim_f = $F/f_animation
@onready var object_f = $F

var door_ch : bool = false # Детектор для нахождение в области двери
var skelet_preload = preload("res://PLay_mobs/Mobs_level_2/skelet.tscn")


func _ready() -> void:
	anim_f.play("f_animate")
	
	var tween_music_start = get_tree().create_tween()
	tween_music_start.tween_property(music, "volume_db", -20.0, 4)
	
	var skelet_1 = skelet_preload.instantiate()
	var skelet_2 = skelet_preload.instantiate()
	var skelet_3 = skelet_preload.instantiate()
	
	skelet_1.position = Vector2 (547, 306)
	skelet_2.position = Vector2 (582, 514)
	skelet_3.position = Vector2 (897, 322)
	
	$Mobs.add_child(skelet_1)
	$Mobs.add_child(skelet_2)
	$Mobs.add_child(skelet_3)
	
	await tween_music_start.finished


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact_f") and door_ch:
		var tween_music_end = get_tree().create_tween()
		tween_music_end.tween_property(music, "volume_db", -60.0, 2)
		PerehodScene.transition()
		
		await PerehodScene.on_transition_finished
		
		music.stop()
		get_tree().change_scene_to_file("res://Levels/Level_4_3.tscn")	


func _on_door_in_level_2_2_body_entered(body: Node2D) -> void:
	if $Mobs.get_child_count() == 0:
		door_ch = true
		object_f.visible = true

func _on_door_in_level_2_2_body_exited(body: Node2D) -> void:
	if $Mobs.get_child_count() == 0:
		door_ch = false
		object_f.visible = false
