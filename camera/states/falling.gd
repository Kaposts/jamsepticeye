extends CameraState
## Falling Camera State
## The falling camera is set when the player is falling in from the air

const LONG_FALL_DURATION_THRESHOLD: float = 0.4

## Based on the player velocity when falling down, camera will slam downwards.
## Larger number makes the camera slam down further
@export_range(0.0, 0.2, 0.001) var long_fall_lookahead_factor: float = 0.09

var _previous_position: Vector2
var _y_position: float
var _from_wall_jump: bool

var _previous_state: String
var _fall_duration: float = 0.0


func enter(previous_state_path: String, data := {}) -> void:
	_previous_position = data[DataType.CURRENT_POSITION]
	_y_position = data[DataType.CURRENT_POSITION].y
	_from_wall_jump = data[DataType.FROM_WALL_JUMP]
	
	_previous_state = previous_state_path


func update(delta: float) -> void:
	if _previous_state == FALLING:
		_fall_duration += delta
	else:
		_fall_duration = 0.0
	
	super(delta)


func apply_focus() -> void:
	# Vertical movement
	if _fall_duration < LONG_FALL_DURATION_THRESHOLD:
		_current_position.y = _y_position + (Vector2.UP.y * _camera.lookahead_y_distance)
	else:
		_camera.global_position.y = lerp(_current_position.y, _player.global_position.y + _player.velocity.y, .05)
		_current_position.y = _player.global_position.y + (_player.velocity.y * long_fall_lookahead_factor)
	
	# Horizontal movement
	if not is_equal_approx(_player.velocity.x, 0.0):
		_current_position.x = _player.global_position.x + sign(_player.velocity.x) * _camera.lookahead_x_distance
	else:
		_current_position.x = _player.global_position.x
