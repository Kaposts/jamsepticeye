extends CameraState
## Wall Hanging Camera State
## The wall hanging camera is set when the player is hanging onto a wall


func apply_focus() -> void:
	_current_position = _player.global_position
