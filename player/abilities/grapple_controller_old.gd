#class_name GrappleController
extends Ability2D
## Grappling Hook Ability to simulate tongue (frog-like creature)
## Reference: https://www.youtube.com/watch?v=niggxMUm0fk&t=298s

var launched: bool = false
var target: Vector2

var _player: Player
var _rest_length: float = 50.0
var _stiffness: float = 100.0
var _damping_factor: float = 0.01

@onready var rope: Line2D = $Line2D
@onready var hook_detector: Area2D = $HookDetector
@onready var hook_detector_collider: CollisionShape2D = $HookDetector/HookDetectorCollider


#===================================================================================================
#region BUILT IN FUNCTIONS

func _ready() -> void:
	_player = get_parent()
	_player.grapple_controller = self
	
	_rest_length = _player.grapple_rest_length
	_stiffness = _player.grapple_stiffness
	_damping_factor = _player.grapple_damping_factor
	(hook_detector_collider.shape as CircleShape2D).radius = _player.grapple_detector_length


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grapple"):
		launch()
	if event.is_action_released("grapple"):
		retract()

#endregion
#===================================================================================================
#region MANADATORY ABSTRACT FUNCTIONS

func apply(player: Node, delta: float) -> void:
	if launched:
		handle_grapple(player, delta)

#endregion
#===================================================================================================
#region PRIVATE FUNCTIONS

func launch() -> void:
	if hook_detector.has_overlapping_bodies():
		launched = true
		_get_closest_target()
		rope.show()


func retract() -> void:
	launched = false
	rope.hide()


func handle_grapple(player: CharacterBody2D, delta: float) -> void:
	var target_direction: Vector2 = player.global_position.direction_to(target)
	var target_distance: float = player.global_position.distance_to(target)
	
	var displacement: float = target_distance - _rest_length
	var force: Vector2 = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude: float = _stiffness * displacement
		var spring_force: Vector2 = target_direction * spring_force_magnitude
		
		var vel_dot: float = player.velocity.dot(target_direction)
		var damping: Vector2 = -_damping_factor * vel_dot * target_direction
		
		force = spring_force + damping
	
	player.velocity += force * delta
	_update_rope()


func _update_rope() -> void:
	rope.set_point_position(1, to_local(target))


func _get_closest_target() -> void:
	var closest_distance: float = 0.0
	for body in hook_detector.get_overlapping_bodies():
		var distance: float = _player.global_position.distance_squared_to(body.global_position)
		if is_equal_approx(closest_distance, 0.0) or distance < closest_distance:
			closest_distance = distance
			target = body.global_position

#endregion
