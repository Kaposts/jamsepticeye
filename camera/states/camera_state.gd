class_name CameraState
extends State
## Base State class for the Player Follow Camera

# State names
const DEFAULT: StringName = "Default"

var _player: Player
var _camera: PlayerFollowCamera


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")
	
	_camera = get_tree().get_first_node_in_group("player_follow_camera")
	assert(_camera != null, "CameraState must be a child of Player Follow Camera node")
	
	SignalBus.player_spawned.connect(_on_player_spawned)
	SignalBus.sig_player_died.connect(_on_player_died)


#region EVENT HANDLERS

func _on_player_spawned() -> void:
	_player = get_tree().get_first_node_in_group("player")
	pass


func _on_player_died() -> void:
	_player = null

#endregion
