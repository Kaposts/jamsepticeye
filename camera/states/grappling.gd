extends CameraState
## Grappling Camera State
## The grappling camera is set when the player is using the grappling hook

var _grapple_anchor_position: Vector2


func enter(_previous_state_path: String, data := {}) -> void:
	_grapple_anchor_position = data[DataType.GRAPPLE_ANCHOR_POSITION]


func apply_focus() -> void:
	# Grappling action:
	_current_position = _grapple_anchor_position
