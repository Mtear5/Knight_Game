extends Node

var last_completed_level = 1  # Значение по умолчанию

func _ready():
	load_progress()

func save_progress(level_number):
	last_completed_level = level_number
	var file = FileAccess.open("res://save.dat", FileAccess.WRITE)
	file.store_32(level_number)  # Сохраняем просто число

func load_progress():
	if FileAccess.file_exists("res://save.dat"):
		var file = FileAccess.open("res://save.dat", FileAccess.READ)
		last_completed_level = file.get_32()
