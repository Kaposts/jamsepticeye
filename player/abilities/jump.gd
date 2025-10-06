extends Ability

var coyote_counter: float = 0.0
var jump_buffer_counter: float = 0.0

var wall_coyote_counter: float = 0.0
var wall_jump_lock_counter: float = 0.0

func apply(player: Player, delta: float) -> void:
	var jump_pressed = Input.is_action_just_pressed("jump")
	var jump_held = Input.is_action_pressed("jump")
	var jump_released = Input.is_action_just_released("jump")

	# --- Ground Check ---
	if player.is_on_floor():
		coyote_counter = player.coyote_time
	else:
		coyote_counter -= delta

	if player.is_on_wall():
		wall_coyote_counter = player.wall_coyote_time
	else:
		wall_coyote_counter -= delta

	# --- Jump Buffer ---
	if jump_pressed:
		jump_buffer_counter = player.jump_buffer_time
	else:
		jump_buffer_counter -= delta

	# --- Jump Logic ---
	if jump_buffer_counter > 0.0:
		# Normal ground jump
		if coyote_counter > 0.0:
			player.is_jumping = true
			perform_jump(player)
			jump_buffer_counter = 0.0
		# Wall jump with wall coyote
		elif (player.is_on_wall() or wall_coyote_counter > 0.0) and player.can_wall_jump:
			player.is_jumping = true
			perform_wall_jump(player, player.wall_dir)
			jump_buffer_counter = 0.0

	# --- Variable jump height ---
	if player.velocity.y < 0: # ascending
		if not jump_held:
			# player released jump early → increase gravity to shorten jump
			player.velocity.y += player.gravity * (player.variable_jump_gravity_multiplier - 1.0) * delta
	elif player.velocity.y > 0: # falling
		player.velocity.y += player.gravity * (player.fall_gravity_multiplier - 1.0) * delta

	if jump_released: player.is_jumping = false

func perform_jump(player):
	# reset vertical velocity
	player.velocity.y = -player.jump_force
	coyote_counter = 0.0

func perform_wall_jump(player, dir: int):
	var outward = player.wall_jump_force.x * dir
	player.velocity.x = outward + (player.input_dir * 100) # input can help steer
	player.velocity.y = player.wall_jump_force.y
	wall_jump_lock_counter = 0.0 # optional: no lock
