class_name PlayerFollowCamera
extends Camera2D
## Dafault camera that follows player
## Defines the behavior of an invisible position that generallu follows the player, but have
## different focuses depneding on context so camera can follow this object instead of the player

@export var lookahead_x_distance: float = 50.0
@export var lookahead_y_distance: float = 30.0

var grapple_controller: GrappleController = null

var _in_air: bool = false
var _current_position: Vector2


func _process(_delta: float) -> void:
	set_state()


func set_state() -> void:
	pass
