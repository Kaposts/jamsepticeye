extends CameraState
## Hovering Camera State
## The hovering camera is set when the player uses the hover ability


func apply_focus() -> void:
	_current_position = _player.global_position
