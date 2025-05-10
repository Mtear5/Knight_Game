extends CharacterBody2D

const SPEED = 170.0
const JUMP_VELOCITY = -350.0

@onready var anim = $AnimatedSprite2D
@onready var hagi = $Hagi
@onready var pre_jump = $pre_jump
@onready var post_jump = $post_jump

var jump_value : bool = false
var dialog_play : bool = false
var enemy_damage_on : bool = false
var health_0 : bool = true
var attack_on : bool = false
var health : int = 100
var damage : int = 15
var player_pos


func _ready() -> void:
	Signals.connect("enemy_attack", _on_damage)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if health > 0:
		if Input.is_action_just_pressed("ui_left"):
			$AttackDirection/DamageBox/HitBox.rotation_degrees = 180
		if Input.is_action_just_pressed("ui_right"):
			$AttackDirection/DamageBox/HitBox.rotation_degrees = 0
		
		if Input.is_action_just_pressed("ui_accept"):
			attack_on = true
			anim.play("Attack")
			$AttackDirection/DamageBox/HitBox/CollisionShape2D.disabled = false
			await anim.animation_finished
			$AttackDirection/DamageBox/HitBox/CollisionShape2D.disabled = true
			attack_on = false
		
		# Handle jump.
		if Input.is_action_just_pressed("ui_up") and is_on_floor() and not(dialog_play) and not(enemy_damage_on) and not(attack_on):
			velocity.y = JUMP_VELOCITY
			anim.play("Jump")
			pre_jump.play()
			jump_value = true

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction and not(dialog_play) and not(enemy_damage_on) and not(attack_on):
			velocity.x = direction * SPEED
			if velocity.y == 0:
				anim.play("Run")
				if $AnimatedSprite2D.frame in [1, 5]:
					hagi.play()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0 and not(enemy_damage_on) and not(attack_on):
				anim.play("Idle")

		if jump_value and velocity.y == 0 and not(enemy_damage_on) and not(attack_on):
					post_jump.play()
					jump_value = false

		if direction == -1 and not(dialog_play):
			$AnimatedSprite2D.flip_h = true
		elif direction == 1 and not(dialog_play):
			$AnimatedSprite2D.flip_h = false

		if velocity.y > 0 and not(enemy_damage_on) and not(attack_on):
			anim.play("Fall")
	
	elif health <= 0 and health_0:
		health_0 = false
		anim.play("Death")
		await anim.animation_finished
		PerehodScene.transition()
		await PerehodScene.on_transition_finished
		get_tree().change_scene_to_file("res://Main_menu/main_menu.tscn")
	
	move_and_slide()
	
	player_pos = position
	Signals.emit_signal("player_position", player_pos)


func _on_damage(enemy_damage):
	if health > 0:
		enemy_damage_on = true
		health -= enemy_damage
		anim.play("Hit")
		await anim.animation_finished
		enemy_damage_on = false
		print(health)


func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("player_attack", damage)
