extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var position_player
var diraction

enum {
	IDLE,
	ATTACK,
	RUN,
	HIT,
	CHASE
}

var state : int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				state_idle()
			ATTACK:
				state_attack()
			RUN:
				pass
			HIT:
				pass
			CHASE:
				state_chase()


func _ready() -> void:
	state = IDLE
	Signals.connect("player_position", _on_player_position)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state == CHASE:
		state_chase()
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	state = ATTACK


func state_idle():
	anim.play("Idle")
	await get_tree().create_timer(1).timeout
	state = CHASE

func state_attack():
	anim.play("Attack")
	await anim.animation_finished
	$AttackDirection/Area2D/CollisionShape2D.disabled = true
	$AttackDirection/Area2D/CollisionShape2D.disabled = false
	state = IDLE

func state_chase():
	diraction = (position_player - self.position).normalized()
	if diraction.x < 0:
		anim.flip_h = true
		$AttackDirection.rotation_degrees = 0
	else:
		anim.flip_h = false
		$AttackDirection.rotation_degrees = 180
	
	
func _on_player_position(player_pos):
	position_player = player_pos
