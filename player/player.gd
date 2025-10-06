class_name Player
extends CharacterBody2D
# Player to define movement behaviors

signal interest_point_detected(entered: bool)


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
@export var finger_time: float = 0.12

@export_group("Grapple Variables")
@export var grapple_detector_length: float = 100.0
@export var grappling_jump_gravity_scale: float = 1.1

@export_group("Grapple_v2 variables")
@export var detach_speed_multiplier: float = 1.0
@export var graple_gravity: float = 1200.0
@export var damping: float = 0.03              # angular damping
@export var max_angular_speed: float = 20.0
@export var swing_boost: float = 1.4           # boost while swinging downward
@export var swing_loss: float = 1.0            # loss while swinging upward
@export var min_length: float = 8.0

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

var is_jumping: bool = false:
	set(flag):
		is_jumping = flag
		if is_jumping:
			is_big_jumping = false
			is_hovering = false
			is_grappling = false
var is_big_jumping: bool = false:
	set(flag):
		is_big_jumping = flag
		if is_big_jumping:
			is_jumping = false
			is_hovering = false
			is_grappling = false
var is_hovering: bool = false:
	set(flag):
		is_hovering = flag
		if is_hovering:
			is_jumping = false
			is_big_jumping = false
			is_grappling = false
var is_grappling: bool = false:
	set(flag):
		is_grappling = flag
		if is_grappling:
			is_jumping = false
			is_big_jumping = false
			is_hovering = false


#endregion
#===================================================================================================
#region NODE VARIABLES

@onready var interest_point_detector: Area2D = $InterestPointDetector
@onready var abilities_root: Node2D = $AbilitiesRoot

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var visuals: Node2D = $Visuals
@onready var body: Node2D = $Visuals/Body
@onready var tongue: Node2D = $Visuals/Tongue
@onready var back_leg_sprite: Sprite2D = $Visuals/BackLeg/BackLegSprite
@onready var front_leg_sprite: Sprite2D = $Visuals/FrontLeg/FrontLegSprite
@onready var back_wing: Node2D = $Visuals/BackWing
@onready var front_wing: Node2D = $Visuals/FrontWing

@onready var die_sfx_player: RandomAudioPlayer2D = $SFX/DieSFXPlayer
@onready var spawn_sfx_player: RandomAudioPlayer2D = $SFX/SpawnSFXPlayer


#===================================================================================================
#region BUILT IN FUNCTIONS

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("player_follow_camera")
	interest_point_detector.body_entered.connect(_on_interest_point_detected)
	interest_point_detector.body_exited.connect(_on_interest_point_exited)
	
	back_wing.hide()
	front_wing.hide()
	tongue.hide()
	
	spawn_sfx_player.play_random()


func _physics_process(delta):
	if velocity.y > 0.0:
		is_big_jumping = false
		is_jumping = false
	
	if is_grappling:
		velocity = Vector2.ZERO
	elif not is_on_floor():
		if can_hover and Input.is_action_just_pressed("jump") and !is_jumping:
			velocity.x = 0
		
		if can_hover and Input.is_action_pressed("jump") and !is_jumping:
			velocity.y = hover_gravity_scale
			is_hovering = true
		else:
			velocity.y += gravity * delta
			is_hovering = false
	else:
		_set_grounded_state()
	
	
	for ability in abilities:
		ability.apply(self, delta)
	
	move_and_slide()
	_sync_animation()

#endregion
#===================================================================================================
#region PUBLIC FUNCTIONS

func die():
	SignalBus.sig_player_died.emit()
	_leave_corpse()
	die_sfx_player.play_random()
	
	await die_sfx_player.finished
	queue_free()


func get_closest_interest_point() -> Vector2:
	if not interest_point_detector.has_overlapping_bodies():
		return Vector2.INF
	
	var closest_point_position: Vector2
	var closest_distance: float = INF
	
	for point in interest_point_detector.get_overlapping_bodies():
		if not point is Node2D:
			continue
		
		var distance: float = global_position.distance_squared_to(body.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_point_position = point.global_position
	
	return closest_point_position


func get_farthest_interest_point() -> Vector2:
	if not interest_point_detector.has_overlapping_bodies():
		return Vector2.INF
	
	var farthest_point_position: Vector2 = Vector2.ZERO
	var farthest_distance: float = 0.0
	
	for point in interest_point_detector.get_overlapping_bodies():
		if not point is Node2D:
			continue
		
		var distance: float = global_position.distance_squared_to(body.global_position)
		if distance >= farthest_distance:
			farthest_distance = distance
			farthest_point_position = point.global_position
	
	return farthest_point_position


func show_wings() -> void:
	back_wing.show()
	front_wing.show()


func wear_shoes() -> void:
	back_leg_sprite.texture = back_sneaker_texture
	front_leg_sprite.texture = front_sneaker_texture


#endregion
#===================================================================================================
#region PRIVATE FUNCTIONS

func _sync_animation() -> void:
	if velocity.x > 0.0:
		visuals.scale.x = -1.0
	elif velocity.x < 0.0:
		visuals.scale.x = 1.0
	
	
	if is_hovering or is_grappling:
		animation_state_machine.travel("hover")
	elif is_on_wall_only():
		animation_state_machine.travel("wall_hang")
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
				c.get_collider().apply_central_impulse(-c.get_normal() * 80)


func _set_grounded_state() -> void:
	is_jumping = false
	is_big_jumping = false
	is_hovering = false
	is_grappling = false


## Leave a sprite of the body in the scene
func _leave_corpse() -> void:
	visuals.reparent(get_parent())

#endregion
#===================================================================================================
#region EVENT HANDLERS

func _on_interest_point_detected(_body: Node2D) -> void:
	interest_point_detected.emit(true)


func _on_interest_point_exited(_body: Node2D) -> void:
	interest_point_detected.emit(false)

#endregion
