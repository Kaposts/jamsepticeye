extends CameraState
## Grappling Camera State
## The grappling camera is set when the player is using the grappling hook


func apply_focus() -> void:
	# Grappling action:
	_current_position = _player.grapple_controller.target
