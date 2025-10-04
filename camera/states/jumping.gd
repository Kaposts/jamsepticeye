extends CameraState
## Jumping Camera State
## The jumping camera is set when the player is jumping

var _previous_position: Vector2
var _y_position: float
var _from_wall_jump: bool


func enter(_previous_state_path: String, data := {}) -> void:
	_previous_position = data[DataType.CURRENT_PLAYER_POSITION]
	_y_position = data[DataType.CURRENT_PLAYER_POSITION].y
	_from_wall_jump = data[DataType.FROM_WALL_JUMP]


func apply_focus() -> void:
	if _from_wall_jump:
		_current_position = _previous_position
		return
	
	# Horizontal movement
	if not is_equal_approx(_player.velocity.x, 0.0):
		_current_position.x = _player.global_position.x + sign(_player.velocity.x) * _camera.lookahead_x_distance
	else:
		_current_position.x = _player.global_position.x
	
	_current_position.y = _y_position + (Vector2.UP.y * _camera.lookahead_y_distance)
