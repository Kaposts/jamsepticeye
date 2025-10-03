class_name PlayerFollowCamera
extends Camera2D
## Dafault camera that follows player
## Defines the behavior of an invisible position that generallu follows the player, but have
## different focuses depneding on context so camera can follow this object instead of the player

@export var lookahead_x_distance: float = 50.0
@export var lookahead_y_distance: float = 30.0


#var _in_air: bool = false
var _player: Player

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
	
	if _player.grapple_controller and _player.grapple_controller.launched:
		state_machine.transition_to_next_state(CameraState.GRAPPLING)
	elif _player.is_hovering:
		state_machine.transition_to_next_state(CameraState.HOVERING)
	elif _player.velocity.y < 0.0:
		state_machine.transition_to_next_state(CameraState.JUMPING)
	
	
	
	else:
		state_machine.transition_to_next_state(CameraState.DEFAULT)
	 

#===================================================================================================
#region EVENT HANDLERS

func _on_player_spawned() -> void:
	_player = get_tree().get_first_node_in_group("player")


func _on_player_died() -> void:
	_player = null

#endregion
