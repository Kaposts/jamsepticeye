extends CameraState
## Jumping Camera State
## The jumping camera is set when the player is jumping


func apply_focus() -> void:
	# Horizontal movement
	if not is_equal_approx(_player.velocity.x, 0.0):
		_current_position.x = _player.global_position.x + sign(_player.velocity.x) * _camera.lookahead_x_distance
	
	_current_position.y = (Vector2.UP.y * _camera.lookahead_y_distance)
