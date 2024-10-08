extends Node

#region OBSTACLE VARIABLES
var ground_obs_scene = preload("res://scenes/obstacles/square_ground_obstacle.tscn")
var flying_enemy_scene = preload("res://scenes/enemies/flying_enemy.tscn")
var obstacle_types := [ground_obs_scene, flying_enemy_scene]
var obstacles : Array
var last_obs : PackedScene
var flying_enemy_heights := [650, 800]
#endregion

#region STARTING POSITIONS
const PLAYER_START_POS := Vector2i(360, 624)
const CAMERA_START_POS := Vector2i(960, 540)
#endregion

#region SCORE VARIABLES
var score : int
const SCORE_MODIFIER : int = 200000
#endregion

#region SPEED VARIABLES
var game_speed : float
const INIT_GAME_SPEED : float = 500
const MAX_GAME_SPEED : int = 2500
const GAME_SPEED_MODIFIER : int = 50000
#endregion

#region WINDOW VARIABLES
var window_size : Vector2i
var left_strafe_bound : float
var right_strafe_bound : float
#endregion

#region GAME VARIABLES
var game_running : bool
#endregion


func _ready() -> void:
	window_size = get_window().size
	
	new_game()


func _process(delta: float) -> void:
	if game_running:
		move_env(delta)
		handle_score()
		handle_speed()
		
		calculate_bounds()
		maintain_bounds()
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD/StartLabel.hide()


#region main_funcs
func new_game() -> void:
	# RESET VARIABLES
	score = 0
	game_running = false
	
	# RESET NODES
	show_score()
	$HUD/StartLabel.show()
	$Player/RunCol.disabled = false
	$Player/DuckCol.disabled = true
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAMERA_START_POS
	$Ground.position = Vector2i(0, 0)

#endregion

#region movement_funcs
func move_env(delta: float) -> void:
	game_speed = INIT_GAME_SPEED
	
	# move dino and camera
	$Player.position.x += game_speed * delta
	$Camera2D.position.x += game_speed * delta
	
	# update ground position
	if $Camera2D.position.x - $Ground.position.x > window_size.x * 1.5:
		$Ground.position.x += window_size.x

func handle_speed() -> void:
	game_speed = (INIT_GAME_SPEED + score) / GAME_SPEED_MODIFIER
	if game_speed > MAX_GAME_SPEED:
		game_speed = MAX_GAME_SPEED

#endregion

#region score_funcs
func handle_score() -> void:
	score += game_speed
	show_score()

func show_score() -> void:
	$"HUD/Score Labels/ScoreLabel".text = "SCORE: " + str(score / SCORE_MODIFIER)

#endregion

#region bounds_funcs
func maintain_bounds() -> void:
	if $Player.position.x < left_strafe_bound:
		$Player.position.x = left_strafe_bound
	if $Player.position.x > right_strafe_bound:
		$Player.position.x = right_strafe_bound

func calculate_bounds() -> void:
	left_strafe_bound = $Camera2D.position.x - (window_size.x * 0.45) # increase to shift left
	right_strafe_bound = $Camera2D.position.x + (window_size.x * 0.15) # decrease tp shift left

#endregion
