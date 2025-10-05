extends CameraState
## Big Jump Camera State
## The camera is set to lookahead a big distance from the direction of the jump


func apply_focus() -> void:
	_current_position.x = _player.global_position.x + sign(_player.velocity.x) * _camera.lookahead_x_distance * 2
	_current_position.y = _player.global_position.y + sign(_player.velocity.y) * _camera.lookahead_x_distance * 2
