class_name GrappleController
extends Ability

signal attached_changed(attached: bool)

const LAUNCHED_MAX_DURATION: float = 0.2

@export var gravity: float = 1400.0
@export var damping: float = 0.03              # angular damping
@export var max_angular_speed: float = 25.0
@export var swing_boost: float = 1.4           # boost while swinging downward
@export var swing_loss: float = 1.0            # loss while swinging upward
@export var min_length: float = 8.0


var attached: bool = false:
	set(flag):
		attached = flag
		tongue_visuals.visible = flag
var anchor: Vector2 = Vector2.ZERO
var length: float = 120.0
var angle: float = 0.0
var angular_velocity: float = 0.0

var _tongue_tip_position: Vector2 = Vector2.ZERO
var _launch_duration: float = 0.0

@onready var detector:Area2D = $HookDetector
@onready var tongue_line: Line2D = %TongueLine
@onready var tongue_tip_sprite: Sprite2D = %TongueTipSprite
@onready var tongue_visuals: Node2D = $TongueVisuals


func _ready() -> void:
	set_physics_process(true)
	tongue_visuals.hide()


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
	
	_launch_tongue_visuals(player)

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


func apply(player: Player, delta: float) -> void:
	var grapple_pressed = Input.is_action_just_pressed("grapple")
	var grapple_released = Input.is_action_just_released("grapple")
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

	_update_tongue_visuals(player, delta)


func _calc_tangential_velocity() -> Vector2:
	return Vector2(angular_velocity * length * cos(angle), -angular_velocity * length * sin(angle))


func _update_tongue_visuals(player: Player, delta: float) -> void:
	tongue_line.set_point_position(0, to_local(player.tongue.global_position))
	
	_launch_duration += delta
	if _launch_duration < LAUNCHED_MAX_DURATION:
		_tongue_tip_position.y = lerpf(_tongue_tip_position.y, to_local(anchor).y, 0.2)
		_tongue_tip_position.x = to_local(anchor).x
		tongue_line.set_point_position(1, _tongue_tip_position)
		tongue_tip_sprite.global_position = to_global(_tongue_tip_position)
	else:
		tongue_line.set_point_position(1, to_local(anchor))
		tongue_tip_sprite.global_position = anchor
	
	tongue_tip_sprite.rotation = player.tongue.global_position.angle_to_point(anchor)


func _launch_tongue_visuals(player: Player) -> void:
	_launch_duration = 0.0
	_tongue_tip_position = to_local(player.tongue.global_position)


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
