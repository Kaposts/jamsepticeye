extends CameraState
## Player Centered Camera State
## The camera is set to centered on the player


func apply_focus() -> void:
	_current_position.y = _player.global_position.y
	
	if is_equal_approx(_player.velocity.x, 0.0):
		_current_position.x = _player.global_position.x
	else:
		_current_position.x = _player.global_position.x + sign(_player.velocity.x) * _camera.lookahead_x_distance
