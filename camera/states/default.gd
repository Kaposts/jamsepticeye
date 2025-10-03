extends CameraState
## Default Camera State
## The default camera is set when the player in on the ground


func apply_focus() -> void:
	_current_position.y = _player.global_position.y + (Vector2.UP.y * _camera.lookahead_y_distance)
	
	# Horizontal movement
	if not is_equal_approx(_player.velocity.x, 0.0):
		_current_position.x = _player.global_position.x + sign(_player.velocity.x) * _camera.lookahead_x_distance
	else:
		_current_position.x = _player.global_position.x
