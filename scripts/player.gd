extends CharacterBody2D

#region PLAYER VARIABLES
const STRAFE_SPEED : int = 300
const FRICTION : int = 75
const GRAVITY : int = 1200
const JUMP_VELOCITY : int = -900
const MIN_JUMP_VELOCITY : int = -600
const FAST_FALL_ACCELERATION : int = 1200
#endregion


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	apply_vertical_movement(delta)
	apply_horizonatal_movement()
	handle_animation()

	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func apply_horizonatal_movement() -> void:
	var direction := Input.get_axis("left", "right")
	if get_parent().game_running:
		if is_on_floor():
			# ACCELERATE
			if direction:
				velocity.x = direction * STRAFE_SPEED
			# DECELERATE
			else:
				velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_vertical_movement(delta: float) -> void:
	if get_parent().game_running:
		# BEGIN JUMP
		if is_on_floor() and Input.is_action_pressed("up"):
			velocity.y = JUMP_VELOCITY
		else:
			# SHORT HOP
			if Input.is_action_just_released("up") and velocity.y < MIN_JUMP_VELOCITY:
				velocity.y = MIN_JUMP_VELOCITY
			# FAST FALL
			if Input.is_action_pressed("down"):
				velocity.y += FAST_FALL_ACCELERATION * delta

func handle_animation() -> void:
	# IDLE TRIGGER
	if not get_parent().game_running:
		$PlayerSprite.play("idle")
	else:
		if is_on_floor():
			# DUCK TRIGGER
			if Input.is_action_pressed("down"):
				$PlayerSprite.play("duck")
				$RunCol.disabled = true
				$DuckCol.disabled = false
			# RUN TRIGGER
			else:
				$PlayerSprite.play("run")
				$RunCol.disabled = false
				$DuckCol.disabled = true
		else:
			# JUMP TRIGGER
			if velocity.y < 0:
				$PlayerSprite.play("jump")
			# FALL TRIGGER
			else:
				$PlayerSprite.play("fall")
