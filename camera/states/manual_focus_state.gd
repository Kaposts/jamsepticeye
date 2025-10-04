extends CameraState
## Manual focus Camera State
## The camera is set to focue on a manual position

var _focus_position: Vector2


func enter(_previous_state_path: String, data := {}) -> void:
	_focus_position = data[DataType.MANUAL_POSITION]


func apply_focus() -> void:
	_current_position = _focus_position
