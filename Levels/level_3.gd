extends Node2D

@onready var label = $CharacterBody2D/Label
@onready var music = $AudioStreamPlayer2D

var door_ch : bool = false # Детектор для нахождение в области двери


func _ready() -> void:
	var tween_label_start = get_tree().create_tween()
	var tween_music_start = get_tree().create_tween()
	tween_music_start.tween_property(music, "volume_db", -30.0, 4)
	tween_label_start.tween_property(label, "modulate:a", 1.0, 2)
	await tween_label_start.finished
	
	
	var tween_label_end = get_tree().create_tween()
	tween_label_end.tween_property(label, "modulate:a", 0.0, 2)
	await tween_label_end.finished
	
	label.visible = false


func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", 110)
