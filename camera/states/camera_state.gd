@abstract class_name CameraState
extends State
## Base State class for the Player Follow Camera

@export_range(0.1, 1.0, .01) var panning_lerp_weight: float = 0.1

# State names
const DEFAULT: StringName = "Default"
const HOVERING: StringName = "Hovering"
const JUMPING: StringName = "Jumping"
const FALLING: StringName = "Falling"
const GRAPPLING: StringName = "Grappling"
const WALL_HANGING: StringName = "WallHanging"
const BIG_JUMPING: StringName = "BigJump"
const INTEREST_POINT: StringName = "InterestPoint"


# Data StringNames
enum DataType{
	CURRENT_PLAYER_POSITION,
	FROM_WALL_JUMP,
	FROM_GROUND,
	MANUAL_POSITION,
}


var _player: Player
var _camera: PlayerFollowCamera
var _current_position: Vector2

#===================================================================================================
#region REQUIRED ABSTRACT FUNCTIONS

## Defines the behavior of the camera mode
@abstract func apply_focus() -> void

#endregion
#===================================================================================================
#region BUILT IN FUNCTIONS

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")
	
	_camera = get_tree().get_first_node_in_group("player_follow_camera")
	assert(_camera != null, "CameraState must be a child of Player Follow Camera node")
	
	SignalBus.player_spawned.connect(_on_player_spawned)
	SignalBus.sig_player_died.connect(_on_player_died)


func update(_delta: float) -> void:
	if not _player:
		return
	
	apply_focus()
	_camera.global_position = lerp(_camera.global_position, _current_position, panning_lerp_weight)

#endregion
#===================================================================================================
#region EVENT HANDLERS

func _on_player_spawned() -> void:
	_player = get_tree().get_first_node_in_group("player")


func _on_player_died() -> void:
	_player = null

#endregion
