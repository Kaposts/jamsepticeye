class_name CameraFocusObject
extends Node2D
## Script that defines the behavior of an invisible Node that generallu follows the player, but have
## different focuses depneding on context so camera can follow this object instead of the player

@export var lookahead_x_distance: float = 50.0
@export var lookahead_y_distance: float = 30.0

var grapple_controller: GrappleController = null

var _player: Player
var _in_air: bool = false
var _current_position: Vector2


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")
	_current_position = _player.global_position


func _process(_delta: float) -> void:
	if _player.is_on_floor() or _player.is_on_wall():
		_in_air = false
	else:
		_in_air = true
	
	apply_focus()
	global_position = _current_position                 


## Defines the focus of the camera
func apply_focus() -> void:
	# Horizontal movement
	if not is_equal_approx(_player.velocity.x, 0.0):
		_current_position.x = _player.global_position.x + sign(_player.velocity.x) * lookahead_x_distance
	else:
		_current_position.x = lerpf(_current_position.x, _player.global_position.x, 0.1)
	
	# Vertical movement
	if not _in_air:
		_current_position.y = _player.global_position.y
	
	# Grappling action:
	if grapple_controller and grapple_controller.launched:
		_current_position = grapple_controller.target
