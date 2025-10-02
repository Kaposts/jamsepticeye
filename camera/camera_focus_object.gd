extends Node2D
## Script that defines the behavior of an invisible Node that follows the player, but have slightly
## different behaviors so camera can follow this object instead of the player

@export var lookahead_x_distance: float = 50.0
@export var lookahead_y_distance: float = 30.0

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
	
	if not is_equal_approx(_player.velocity.x, 0.0):
		_current_position.x = _player.global_position.x + sign(_player.velocity.x) * lookahead_x_distance
	else:
		_current_position.x = lerpf(_current_position.x, _player.global_position.x, 0.1)
	
	if not _in_air:
		_current_position.y = _player.global_position.y
	
	
	global_position = _current_position                 
