extends Node


const PLAYER_START_POS : Vector2i = Vector2i(360, 624)
const CAMERA_START_POS : Vector2i = Vector2i(960, 540)

var game_speed : float
const INIT_GAME_SPEED : int = 500
const MAX_SPEED : int = 2500

var window_size : Vector2i
var left_strafe_bound : float
var right_strafe_bound : float


func _ready() -> void:
	window_size = get_window().size
	
	new_game()


func _process(delta: float) -> void:
	move_env(delta)
	calculate_bounds()
	maintain_bounds()


func new_game() -> void:
	$Player/PlayerSprite.play("idle")
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAMERA_START_POS
	$Ground.position = Vector2i(0, 0)

func move_env(delta: float) -> void:
	game_speed = INIT_GAME_SPEED
	
	$Player.position.x += game_speed * delta
	$Camera2D.position.x += game_speed * delta
	
	if $Camera2D.position.x - $Ground.position.x > window_size.x * 1.5:
		$Ground.position.x += window_size.x

func maintain_bounds() -> void:
	if $Player.position.x < left_strafe_bound:
		$Player.position.x = left_strafe_bound
	if $Player.position.x > right_strafe_bound:
		$Player.position.x = right_strafe_bound

func calculate_bounds() -> void:
	left_strafe_bound = $Camera2D.position.x - (window_size.x * 0.45) # increase to shift left
	right_strafe_bound = $Camera2D.position.x + (window_size.x * 0.15) # decrease tp shift left
