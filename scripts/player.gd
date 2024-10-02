extends CharacterBody2D

# init values
@export var SPEED : int = 300
@export var FRICTION : int = 75
@export var GRAVITY : int = 800
@export var JUMP_VELOCITY : int = -600
@export var MIN_JUMP_VELOCITY : int = -400
@export var FAST_FALL_ACCELERATION : int = 1200


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
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_vertical_movement(delta) -> void:
	if is_on_floor():
		if Input.is_action_pressed("up"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("up") and velocity.y < MIN_JUMP_VELOCITY:
			velocity.y = MIN_JUMP_VELOCITY
		
		if Input.is_action_pressed("down"):
			velocity.y += FAST_FALL_ACCELERATION * delta
