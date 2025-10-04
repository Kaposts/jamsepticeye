class_name PlayerFollowCamera
extends Camera2D
## Dafault camera that follows player
## Defines the behavior of an invisible position that generallu follows the player, but have
## different focuses depneding on context so camera can follow this object instead of the player

@export var lookahead_x_distance: float = 50.0
@export var lookahead_y_distance: float = 30.0

var _player: Player
var _previous_position: Vector2 = Vector2.ZERO
var _from_wall_jump: bool = false

@onready var state_machine: StateMachine = $StateMachine


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")
	SignalBus.player_spawned.connect(_on_player_spawned)
	SignalBus.sig_player_died.connect(_on_player_died)


func _process(_delta: float) -> void:
	set_state()


func set_state() -> void:
	if not _player:
		return
	
	
	if _player.is_grappling:
		var grapple_controller: GrappleController = get_tree().get_first_node_in_group("grapple_controller")
		state_machine.transition_to_next_state(
			CameraState.GRAPPLING,
			{CameraState.DataType.GRAPPLE_ANCHOR_POSITION : grapple_controller.anchor})
	elif _player.is_on_wall_only() and not _player.is_on_ceiling():
		_previous_position = _player.global_position
		_from_wall_jump = true
		state_machine.transition_to_next_state(CameraState.WALL_HANGING)
	elif _player.is_hovering:
		_previous_position = _player.global_position
		state_machine.transition_to_next_state(CameraState.HOVERING)
	elif _player.velocity.y < 0.0 or _player.is_on_ceiling_only():
		state_machine.transition_to_next_state(
			CameraState.JUMPING,
			{CameraState.DataType.CURRENT_POSITION : _previous_position,
			 CameraState.DataType.FROM_WALL_JUMP : _from_wall_jump})
	elif _player.velocity.y > 0.0:
		state_machine.transition_to_next_state(
			CameraState.FALLING,
			{CameraState.DataType.CURRENT_POSITION : _previous_position,
			 CameraState.DataType.FROM_WALL_JUMP : _from_wall_jump})
	
	else:
		_previous_position = _player.global_position
		_from_wall_jump = false
		state_machine.transition_to_next_state(CameraState.DEFAULT)
	 

#===================================================================================================
#region EVENT HANDLERS

func _on_player_spawned() -> void:
	_player = get_tree().get_first_node_in_group("player")


func _on_player_died() -> void:
	_player = null

#endregion
