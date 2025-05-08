extends CharacterBody2D

const SPEED = 170.0
const JUMP_VELOCITY = -350.0

@onready var anim = $AnimatedSprite2D
@onready var hagi = $Hagi
@onready var pre_jump = $pre_jump
@onready var post_jump = $post_jump

var jump_value : bool = false
var dialog_play : bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor() and not(dialog_play):
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		pre_jump.play()
		jump_value = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and not(dialog_play):
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
			if $AnimatedSprite2D.frame in [1, 5]:
				hagi.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")

	if jump_value and velocity.y == 0:
				post_jump.play()
				jump_value = false

	if direction == -1 and not(dialog_play):
		$AnimatedSprite2D.flip_h = true
	elif direction == 1 and not(dialog_play):
		$AnimatedSprite2D.flip_h = false

	if velocity.y > 0:
		anim.play("Fall")

	move_and_slide()
