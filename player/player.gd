class_name Player
extends CharacterBody2D
# Player to define movement behaviors


@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var camera: PlayerFollowCamera
@export var front_sneaker_texture: Texture2D
@export var back_sneaker_texture: Texture2D

#===================================================================================================
#region MOVEMENT SETTINGS

@export_group("Walk Variables")
@export var acceleration: float = 1200.0
@export var speed := 150

@export_group("Jump Variables")
@export var jump_force: float = 400.0
@export var fall_gravity_multiplier: float = 2.0
@export var variable_jump_gravity_multiplier: float = 2.5
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

@export_group("Wall Jump Variables")
@export var wall_jump_force: Vector2 = Vector2(200, -400)
@export var wall_jump_lock_time: float = 0.18
@export var wall_coyote_time: float = 0.12

@export_group("Claw Variables")
@export var wall_slide_speed: float = 80.0

@export_group("finger variables")
@export var finger_force: Vector2 = Vector2(2000, -400)

@export_group("Grapple Variables")
@export var grapple_detector_length: float = 100.0
@export var grappling_jump_gravity_scale: float = 1.1

@export_group("Grapple_v2 variables")
@export var detach_speed_multiplier: float = 1.0

@export_group("hover variables")
@export var hover_gravity_scale: float = 0.3   # how much gravity applies while hovering (0.3 = 30%)
@export var hover_move_speed: float = 100.0    # reduced horizontal speed while hovering

#endregion
#===================================================================================================
#region STATE VARIBALES

var abilities: Array = []

var can_wall_jump: bool = false
var can_hover: bool = false
var can_push: bool = false
var wall_dir = 0
var input_dir: float
var wall_jump_lock_counter: float
var is_jumping: bool = false
var is_hovering: bool = false
var is_grappling: bool = false
var jump_from_grappling: bool = false
var need_animation_reset: bool = false


#endregion
#===================================================================================================
#region NODE VARIABLES
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var visuals: Node2D = $Visuals
@onready var body: Node2D = $Visuals/Body



func _ready() -> void:
	camera = get_tree().get_first_node_in_group("player_follow_camera")


func _physics_process(delta):
	if is_grappling:
		velocity = Vector2.ZERO
		is_hovering = false
	elif not is_on_floor():
		if can_hover and Input.is_action_just_pressed("ui_accept") and !is_jumping:
			velocity.x = 0
		
		if can_hover and Input.is_action_pressed("ui_accept") and !is_jumping:
			velocity.y = hover_gravity_scale
			is_hovering = true
		else:
			velocity.y += gravity * delta
			is_hovering = false
	else:
		is_hovering = false
	
	if is_on_floor() or is_on_wall():
		jump_from_grappling = false
	
	for ability in abilities:
		ability.apply(self, delta)
	
	move_and_slide()
	_sync_animation()


func _sync_animation() -> void:
	if velocity.x > 0.0:
		visuals.scale.x = -1.0
	elif velocity.x < 0.0:
		visuals.scale.x = 1.0
	
	if is_hovering:
		animation_state_machine.travel("hover")
	elif velocity.y < 0.0:
		animation_state_machine.travel("jump")
	elif velocity.y > 0.0:
		animation_state_machine.travel("fall")
	elif velocity.is_equal_approx(Vector2.ZERO):
		animation_state_machine.travel("idle")
	else:
		animation_state_machine.travel("walk")



	if can_push:
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				c.get_collider().apply_central_impulse(-c.get_normal() * 30)


func die():
	SignalBus.sig_player_died.emit()
	_leave_corpse()
	queue_free()


## Leave a sprite of the body in the scene
func _leave_corpse() -> void:
	visuals.reparent(get_parent())
