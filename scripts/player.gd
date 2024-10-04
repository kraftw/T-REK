extends CharacterBody2D


const STRAFE_SPEED : int = 300
const FRICTION : int = 75
const GRAVITY : int = 1200
const JUMP_VELOCITY : int = -900
const MIN_JUMP_VELOCITY : int = -600
const FAST_FALL_ACCELERATION : int = 1200


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	apply_vertical_movement(delta)
	apply_horizonatal_movement()

	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func apply_horizonatal_movement() -> void:
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * STRAFE_SPEED
		if is_on_floor():
			$PlayerSprite.play("run")
			$RunCol.disabled = false
			$DuckCol.disabled = true
			if Input.is_action_pressed("down"):
				$PlayerSprite.play("duck")
				$RunCol.disabled = true
				$DuckCol.disabled = false
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_vertical_movement(delta: float) -> void:
	if is_on_floor():
		$PlayerSprite.play("run")
		if Input.is_action_pressed("up"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("up") and velocity.y < MIN_JUMP_VELOCITY:
			velocity.y = MIN_JUMP_VELOCITY
			
		if Input.is_action_pressed("down"):
			velocity.y += FAST_FALL_ACCELERATION * delta
		
		if velocity.y < 0:
			$PlayerSprite.play("jump")
		else:
			$PlayerSprite.play("fall")
