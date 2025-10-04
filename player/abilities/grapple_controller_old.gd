#class_name GrappleController
extends Ability2D
## Grappling Hook Ability to simulate tongue (frog-like creature)
## Reference: https://gameidea.org/2024/08/24/make-grappling-hook-in-godot/

@export var grappling_jump_modifier: float = 1.5

var target: Vector2
var grapple_system: GrappleSystem = null

var _player: Player

@onready var hook_detector: Area2D = $HookDetector
@onready var hook_detector_collider: CollisionShape2D = $HookDetector/HookDetectorCollider



#===================================================================================================
#region BUILT IN FUNCTIONS

func _ready() -> void:
	_player = get_parent()
	(hook_detector_collider.shape as CircleShape2D).radius = _player.grapple_detector_length


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grapple"):
		attach_player()
	if event.is_action_released("grapple") or event.is_action_pressed("jump"):
		detach_player()


#endregion
#===================================================================================================
#region MANADATORY ABSTRACT FUNCTIONS

func apply(player: Player, _delta: float) -> void:
	if player.is_grappling:
		player.global_position = grapple_system.player_anchor.global_position

#endregion
#===================================================================================================
#region PUBLIC FUNCTIONS

# Function to make the _player a child of player_anchor and make
# all the things visible and working.
func attach_player() -> void:
	if not hook_detector.has_overlapping_bodies():
		return
	
	_player.is_grappling = true
	_get_closest_target()
	
	grapple_system = GrappleSystemFactory.new_grapple(_player.get_parent(), target, _player.global_position)


# Function to make the _player no longer a child of player_anchor
# and make all the things invisible and not working.
func detach_player() -> void:
	if not grapple_system:
		return
	
	_transfer_angular_velocity()
	_player.is_grappling = false
	_player.jump_from_grappling = true
	grapple_system.queue_free()
	grapple_system = null


func _transfer_angular_velocity() -> void:
	_player.velocity.y = grapple_system.player_anchor.linear_velocity.y * grappling_jump_modifier
	_player.velocity.x = signf(grapple_system.player_anchor.linear_velocity.x) *\
						 grapple_system.player_anchor.linear_velocity.length() *\
						 grappling_jump_modifier


func _get_closest_target() -> void:
	var closest_distance: float = 0.0
	for body in hook_detector.get_overlapping_bodies():
		var distance: float = _player.global_position.distance_squared_to(body.global_position)
		if is_equal_approx(closest_distance, 0.0) or distance < closest_distance:
			closest_distance = distance
			target = body.global_position

#endregion
