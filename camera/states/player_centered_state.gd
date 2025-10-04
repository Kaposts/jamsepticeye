extends CameraState
## Player Centered Camera State
## The camera is set to centered on the player


func apply_focus() -> void:
	_current_position = _player.global_position
