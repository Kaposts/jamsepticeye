extends Ability

@export var jump_force: float = 400.0
@export var fall_gravity_multiplier: float = 2.0
@export var variable_jump_gravity_multiplier: float = 2.5

@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

var coyote_counter: float = 0.0
var jump_buffer_counter: float = 0.0

@export var wall_jump_force: Vector2 = Vector2(200, -400)
@export var wall_jump_lock_time: float = 0.18
@export var wall_coyote_time: float = 0.12
var wall_coyote_counter: float = 0.0
var wall_jump_lock_counter: float = 0.0

func apply(player, delta):
	var jump_pressed = Input.is_action_just_pressed("ui_accept")
	var jump_held = Input.is_action_pressed("ui_accept")

	# --- Ground Check ---
	if player.is_on_floor():
		coyote_counter = coyote_time
	else:
		coyote_counter -= delta

	if player.is_on_wall():
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
			perform_jump(player)
			jump_buffer_counter = 0.0
		# Wall jump with wall coyote
		elif (player.is_on_wall() or wall_coyote_counter > 0.0) and player.can_wall_jump:
			perform_wall_jump(player, player.wall_dir)
			jump_buffer_counter = 0.0

	# --- Variable jump height ---
	if player.velocity.y < 0: # ascending
		if not jump_held:
			# player released jump early → increase gravity to shorten jump
			player.velocity.y += player.gravity * (variable_jump_gravity_multiplier - 1.0) * delta
	elif player.velocity.y > 0: # falling
		player.velocity.y += player.gravity * (fall_gravity_multiplier - 1.0) * delta

func perform_jump(player):
	# reset vertical velocity
	player.velocity.y = -jump_force
	coyote_counter = 0.0

func perform_wall_jump(player, dir: int):
	var outward = wall_jump_force.x * dir
	player.velocity.x = outward + (player.input_dir * 100) # input can help steer
	player.velocity.y = wall_jump_force.y
	wall_jump_lock_counter = 0.0 # optional: no lock
