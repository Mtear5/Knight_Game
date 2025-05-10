extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var position_player
var diraction
var damage : int = 20
var health : int = 100

enum {
	IDLE,
	ATTACK,
	RUN,
	HIT,
	CHASE,
	DEATH
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
				state_hit()
			CHASE:
				state_chase()
			DEATH:
				state_death()


func _ready() -> void:
	state = IDLE
	Signals.connect("player_position", _on_player_position)
	Signals.connect("player_attack", _on_damage)


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
	$AttackDirection/Area2D/CollisionShape2D.disabled = false
	anim.play("Idle")
	await get_tree().create_timer(1).timeout
	state = CHASE

func state_attack():
	anim.play("Attack")
	await anim.animation_finished
	$AttackDirection/DamageBox/HitBox/CollisionShape2D.disabled = false
	await get_tree().create_timer(0.1).timeout
	$AttackDirection/DamageBox/HitBox/CollisionShape2D.disabled = true
	
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

func state_hit():
	$AttackDirection/Area2D/CollisionShape2D.disabled = true
	anim.play("Hit")
	await anim.animation_finished
	state = IDLE

func state_death():
	$AttackDirection/Area2D/CollisionShape2D.disabled = true
	anim.play("Death")
	await anim.animation_finished
	queue_free()
	
func _on_player_position(player_pos):
	position_player = player_pos


func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage)

func _on_damage(player_damage):
	health -= player_damage
	if health <= 0:
		state = DEATH
	else:
		state = IDLE
		state = HIT
	
