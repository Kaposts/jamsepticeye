extends CameraState
## Default Camera State


func update(_delta: float) -> void:
	if not _player:
		return
	
	if _player.is_on_floor() or _player.is_on_wall():
		_camera._in_air = false
	else:
		_camera._in_air = true
	
	apply_focus()
	_camera.global_position = _camera._current_position                 


#endregion
#===================================================================================================
#region PUBLIC FUNCTIONS

## Defines the focus of the camera
func apply_focus() -> void:
	# Horizontal movement
	if not is_equal_approx(_player.velocity.x, 0.0):
		_camera._current_position.x = _player.global_position.x + sign(_player.velocity.x) * _camera.lookahead_x_distance
	else:
		_camera._current_position.x = lerpf(_camera._current_position.x, _player.global_position.x, 0.1)
	
	# Vertical movement
	if not _camera._in_air:
		_camera._current_position.y = _player.global_position.y
	
	# Grappling action:
	if _camera.grapple_controller and _camera.grapple_controller.launched:
		_camera._current_position = _camera.grapple_controller.target

#endregion
