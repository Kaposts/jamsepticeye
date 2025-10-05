extends CharacterBody2D

@export var move_speed: float = 200.0
@export var acceleration: float = 1200.0

@export var jump_force: float = 400.0
@export var fall_gravity_multiplier: float = 2.0
@export var variable_jump_gravity_multiplier: float = 2.5

@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

@export var wall_slide_speed: float = 80.0

@export var wall_jump_force: Vector2 = Vector2(200, -400)
@export var wall_jump_lock_time: float = 0.18
@export var wall_coyote_time: float = 0.12
var wall_coyote_counter: float = 0.0

@export var floor_check_distance: float = 2.0
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var input_direction: float

var coyote_counter: float = 0.0
var jump_buffer_counter: float = 0.0
var wall_jump_lock_counter: float = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	# --- Input ---
	input_direction = Input.get_axis("move_left", "move_right")
	var jump_pressed = Input.is_action_just_pressed("jump")
	var jump_held = Input.is_action_pressed("jump")

	# --- Ground Check ---
	if is_on_floor():
		coyote_counter = coyote_time
	else:
		coyote_counter -= delta

	# --- Wall Check ---
	var is_touching_wall = is_on_wall()
	var wall_dir = 0
	if is_touching_wall:
		wall_dir = sign(get_wall_normal().x)
		wall_coyote_counter = wall_coyote_time
	else:
		wall_coyote_counter -= delta

	# --- Jump Buffer ---
	if jump_pressed:
		jump_buffer_counter = jump_buffer_time
	else:
		jump_buffer_counter -= delta

	# --- Jump Logic ---
	if jump_buffer_counter > 0.0:
		# Normal ground jump
		if coyote_counter > 0.0:
			perform_jump()
			jump_buffer_counter = 0.0
		# Wall jump with wall coyote
		elif (is_touching_wall or wall_coyote_counter > 0.0) and not is_on_floor():
			perform_wall_jump(-wall_dir)
			jump_buffer_counter = 0.0

	# --- Horizontal Movement ---
	var target_vel_x = input_direction * move_speed
	
	if wall_jump_lock_counter > 0.0:
		target_vel_x = 0
		wall_jump_lock_counter -= delta

	velocity.x = move_toward(velocity.x, target_vel_x, acceleration * delta)

	# --- Variable jump height ---
	if velocity.y < 0: # ascending
		if not jump_held:
			# player released jump early → increase gravity to shorten jump
			velocity.y += gravity * (variable_jump_gravity_multiplier - 1.0) * delta
	elif velocity.y > 0: # falling
		velocity.y += gravity * (fall_gravity_multiplier - 1.0) * delta


	# --- Wall Slide ---
	if is_touching_wall and not is_on_floor() and velocity.y > 0:
		if velocity.y > wall_slide_speed:
			velocity.y = wall_slide_speed

	# --- Apply Movement ---
	move_and_slide()

func perform_jump():
	# reset vertical velocity
	velocity.y = -jump_force
	coyote_counter = 0.0

func perform_wall_jump(dir: int):
	var outward = wall_jump_force.x * -dir
	velocity.x = outward + (input_direction * 100) # input can help steer
	
	velocity.y = wall_jump_force.y
	wall_jump_lock_counter = 0.0 # optional: no lock
