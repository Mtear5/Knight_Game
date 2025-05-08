extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var player = $"../CharacterBody2D"

func _ready() -> void:
	anim.play("Idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	player.dialog_play = true
	Dialogic.start("timeline_1")
