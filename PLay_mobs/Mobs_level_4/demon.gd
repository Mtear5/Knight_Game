extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var position_player
var diraction
var player_dmg : int
var damage : int = 10
var health : int = 100
var speed : int = 120
var attack_on : bool = false
var hit_on : bool = false
var dialog_for_player_on : bool = true

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
				state_run()
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
	
	if not(dialog_for_player_on):
		if state == CHASE and health > 0:
			state_chase()
		elif state == RUN and not(attack_on) and health > 0:
			state_run()
	
	move_and_slide()


func state_idle():
	if health > 0:
		anim.play("Idle")
		await get_tree().create_timer(1).timeout
		state = CHASE

func state_attack():
	if health > 0:
		attack_on = true
		velocity.x = 0
		anim.play("Attack")
		await anim.animation_finished
		if not(hit_on):
			$AttackDirection/DamageBox/HitBox/CollisionShape2D.disabled = false
			await get_tree().create_timer(0.2).timeout
			$AttackDirection/DamageBox/HitBox/CollisionShape2D.disabled = true

		$AttackDirection/Area2D/CollisionShape2D.disabled = true
		$AttackDirection/Area2D/CollisionShape2D.disabled = false
		state = IDLE

		$DetectPlayer/CollisionShape2D.disabled = true
		$DetectPlayer/CollisionShape2D.disabled = false
		attack_on = false

func state_chase():
	if health > 0:
		velocity.x = 0
		anim.play("Idle")
		diraction = (position_player - self.position).normalized()
		if diraction.x < 0:
			anim.flip_h = false
			$AttackDirection.rotation_degrees = 0
		else:
			anim.flip_h = true
			$AttackDirection.rotation_degrees = 180
			
		$DetectPlayer/CollisionShape2D.disabled = true
		$DetectPlayer/CollisionShape2D.disabled = false

func state_hit():
	hit_on = true
	if health > 0:
		$AttackDirection/Area2D/CollisionShape2D.disabled = true
		anim.play("Hit")
		await anim.animation_finished
		state = IDLE
		attack_on = false
	hit_on = false

func state_death():
	velocity.x = 0
	$AttackDirection/Area2D/CollisionShape2D.disabled = true
	$AttackDirection/DamageBox/HitBox/CollisionShape2D.disabled = true
	$AttackDirection.position.y = 300
	anim.play("Death")
	await anim.animation_finished
	queue_free()
	
func state_run():
	if health > 0:
		anim.play("Run")
		diraction = (position_player - self.position).normalized()
		if diraction.x < 0:
			anim.flip_h = false
			$AttackDirection.rotation_degrees = 0
		else:
			anim.flip_h = true
			$AttackDirection.rotation_degrees = 180
		velocity.x = diraction.x * speed
	
func _on_player_position(player_pos):
	position_player = player_pos
	

func _on_damage(player_damage):
	player_dmg = player_damage


func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage)


func _on_area_2d_body_entered(body: Node2D) -> void:
	attack_on = true
	state = ATTACK


func _on_detect_player_body_entered(body: Node2D) -> void:
	if health > 0:
		state = RUN


func _on_detect_player_body_exited(body: Node2D) -> void:
	state = CHASE


func _on_hurt_box_area_entered(area: Area2D) -> void:
	health -= player_dmg
	if health <= 0:
		state = DEATH
	else:
		state = IDLE
		state = HIT


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
