class_name GrappleController
extends Ability

signal attached_changed(attached: bool)

@export var gravity: float = 1400.0
@export var damping: float = 0.03              # angular damping
@export var max_angular_speed: float = 25.0
@export var swing_boost: float = 1.4           # boost while swinging downward
@export var swing_loss: float = 1.0            # loss while swinging upward
@export var min_length: float = 8.0

# Debug rope rendering
@export var draw_rope: bool = true
@export var rope_color: Color = Color(1, 1, 1, 0.9)
@export var rope_width: float = 2.0

var attached: bool = false
var anchor: Vector2 = Vector2.ZERO
var length: float = 120.0
var angle: float = 0.0
var angular_velocity: float = 0.0

@onready var detector:Area2D = $HookDetector

func _ready() -> void:
	set_physics_process(true)


func attach(player: Player, anchor_pos: Vector2) -> void:
	if player == null:
		return
		
	anchor = anchor_pos

	var to_player = player.global_position - anchor
	length = max(min_length, to_player.length())

	# angle measured from vertical
	angle = atan2(to_player.x, to_player.y)

	# initialize angular velocity from player.velocity if exists
	var tangent := Vector2(cos(angle), -sin(angle))
	angular_velocity = player.velocity.dot(tangent) / length

	attached = true
	player.is_grappling = true
	attached_changed.emit(true)
	queue_redraw()


func detach(player: Player) -> void:
	if not attached:
		return

	var release_vel := _calc_tangential_velocity()

	# Base multiplier
	release_vel *= player.detach_speed_multiplier

	# Extra horizontal sling effect
	var horizontal_boost = abs(release_vel.x) / max(1.0, release_vel.length())
	release_vel.x *= (1.0 + horizontal_boost * 0.3)  # tweak 1.2 for more/less boost

	player.velocity = release_vel

	attached = false
	player.is_grappling = false
	attached_changed.emit(false)
	queue_redraw()


func apply(player: Player, delta: float) -> void:
	var grapple_pressed = Input.is_action_just_pressed("grapple")
	var grapple_released = Input.is_action_just_released("grapple")

	print(get_closest_grapple_target(player))
	var closest_point = get_closest_grapple_target(player)

	if grapple_pressed and closest_point: attach(player, closest_point.global_position)

	if grapple_released and attached: detach(player)

	if not attached or player == null:
		return

	if player.is_on_floor() or player.is_on_wall(): detach(player)

	# pendulum physics
	var angular_acc := -(gravity / length) * sin(angle) - damping * angular_velocity
	angular_velocity += angular_acc * delta

	# Boost momentum when swinging down, lose when up
	if angle * angular_velocity < 0.0:
		angular_velocity *= 1.0 + (swing_boost * delta)
	else:
		angular_velocity *= max(0.0, 1.0 - (swing_loss * delta))

	angular_velocity = clamp(angular_velocity, -max_angular_speed, max_angular_speed)
	angle += angular_velocity * delta

	# Update player position
	var new_pos := anchor + Vector2(length * sin(angle), length * cos(angle))
	var vel := _calc_tangential_velocity()

	player.global_position = new_pos
	player.velocity = vel

	queue_redraw()


func _calc_tangential_velocity() -> Vector2:
	return Vector2(angular_velocity * length * cos(angle), -angular_velocity * length * sin(angle))


func _draw() -> void:
	var player = get_parent()
	if draw_rope and attached and player:
		draw_line(to_local(anchor), to_local(player.global_position), rope_color, rope_width)


func is_attached() -> bool:
	return attached

func get_closest_grapple_target(player: Node2D) -> Node2D:
	var closest: Node2D = null
	var closest_distance := INF
	
	for body in detector.get_overlapping_bodies():
		if not body is Node2D:
			continue
		
		var dist := player.global_position.distance_squared_to(body.global_position)
		if dist < closest_distance:
			closest_distance = dist
			closest = body
	
	return closest
