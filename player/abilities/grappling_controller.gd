extends Ability2D
## Grappling Hook Ability to simulate tongue (frog-like creature)

#@export var rest_length = 20.0
#@export var stiffness = 60.0
#@export var damping_factor = 0.1
#
#@onready var ray: RayCast2D = $RayCast2D
#@onready var rope: Line2D = $Line2D
#
#var launched: bool = false
#var target: Vector2 = Vector2.ZERO
#
#
#func apply(player: Node, delta: float) -> void:
	#ray.look_at(get_global_mouse_position())
	#
	#if Input.is_action_just_pressed("grapple"):
		#_launch()
	#if Input.is_action_just_released("grapple"):
		#_retract()
	#
	#if launched:
		#_handle_grapple(player, delta)
#
#
#func _launch() -> void:
	#if ray.is_colliding():
		#launched = true
		#ray.get_collision_point()
#
#
#func _retract() -> void:
	#launched = false
#
#
#func _handle_grapple(player: CharacterBody2D, delta: float) -> void:
	#var target_direction: Vector2 = player.global_position.direction_to(target)
	#var target_distance: float = player.global_position.distance_to(target)
	#
	#var displacement: float = target_distance - rest_length
	#var force: Vector2 = Vector2.ZERO
	#
	#if not is_equal_approx(displacement, 0.0):
		#var spring_force_magnitude: float = stiffness * displacement
		#var spring_force: Vector2 = target_direction * spring_force_magnitude
		#
		#var velecity_dot: float = player.velocity.dot(target_direction)
		#var damping: Vector2 = -damping_factor * velecity_dot * target_direction
		#
		#force = spring_force * damping
	#
	#player.velocity += force * delta
	#_draw_rope()
#
#
#func _draw_rope() -> void:
	#rope.set_point_position(1, to_local(target))

#extends Ability2D
#
@export var rest_length: float = 20.0
@export var stiffness: float = 60.0
@export var damping_factor: float = 0.1

@onready var ray: RayCast2D = $RayCast2D
@onready var rope: Line2D = $Line2D

var launched: bool = false
var target: Vector2


func apply(player: Node, delta: float) -> void:
	ray.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("grapple"):
		launch()
	if Input.is_action_just_released("grapple"):
		retract()
	
	if launched:
		handle_grapple(player, delta)


func launch() -> void:
	if ray.is_colliding():
		launched = true
		target = ray.get_collision_point()
		rope.show()


func retract() -> void:
	launched = false
	rope.hide()


func handle_grapple(player: CharacterBody2D, delta: float) -> void:
	var target_direction: Vector2 = player.global_position.direction_to(target)
	var target_distance: float = player.global_position.distance_to(target)
	
	var displacement: float = target_distance - rest_length
	var force: Vector2 = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude: float = stiffness * displacement
		var spring_force: Vector2 = target_direction * spring_force_magnitude
		
		var vel_dot: float = player.velocity.dot(target_direction)
		var damping: Vector2 = -damping_factor * vel_dot * target_direction
		
		force = spring_force + damping
	
	player.velocity += force * delta
	update_rope()

func update_rope() -> void:
	rope.set_point_position(1, to_local(target))
