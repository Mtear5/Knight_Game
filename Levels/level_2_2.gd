extends Node2D

@onready var music = $AudioStreamPlayer2D

var door_ch : bool = false # Детектор для нахождение в области двери


func _ready() -> void:
	var tween_music_start = get_tree().create_tween()
	tween_music_start.tween_property(music, "volume_db", -20.0, 4)
	await tween_music_start.finished
