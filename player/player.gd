extends CharacterBody2D

var abilities: Array = []

@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_group("walk variables")
@export var acceleration: float = 1200.0
@export var speed := 150

@export_group("jump variables")
@export var jump_force: float = 400.0
@export var fall_gravity_multiplier: float = 2.0
@export var variable_jump_gravity_multiplier: float = 2.5
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

@export_group("wall jump variables")
@export var wall_jump_force: Vector2 = Vector2(200, -400)
@export var wall_jump_lock_time: float = 0.18
@export var wall_coyote_time: float = 0.12

@export_group("claw variables")
@export var wall_slide_speed: float = 80.0

var can_wall_jump: bool = false
var wall_dir = 0
var input_dir: float
var wall_jump_lock_counter: float

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	for ability in abilities:
		ability.apply(self, delta)

	move_and_slide()
