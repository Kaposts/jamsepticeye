class_name GrappleSystem
extends Node2D
## Grapple system that can be instantiated to create grappling action

const SWING_SPEED_LIMIT: float = 350.0

## How much force to apply to the _player anchor when the _player move left or right when swinging
@export var push_force: float = 60.0

@onready var grapple_anchor: StaticBody2D = $GrappleAnchor
@onready var player_anchor: RigidBody2D = $PlayerAnchor
@onready var pin_joint: PinJoint2D = $PinJoint2D
@onready var rope: Line2D = $Rope


func _process(_delta: float) -> void:
	_update_rope()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		# if already moving fast, don't move faster
		if player_anchor.linear_velocity.length() < SWING_SPEED_LIMIT:
			player_anchor.apply_central_impulse(player_anchor.global_transform.x * push_force)
	elif event.is_action_pressed("ui_left"):
		if player_anchor.linear_velocity.length() < SWING_SPEED_LIMIT:
			player_anchor.apply_central_impulse(player_anchor.global_transform.x * -push_force)



func _update_rope() -> void:
	rope.set_point_position(0, grapple_anchor.position)
	rope.set_point_position(1, player_anchor.position)
