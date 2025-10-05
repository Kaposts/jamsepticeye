extends Ability

var timer: float
var finger_buffer_counter: float = 0.0
var wall_coyote_counter: float = 0.0

func apply(player, delta):
	# if Input.is_action_just_pressed("finger") and player.is_on_wall():
	# 	finger(player, player.wall_dir)

	if player.is_on_wall():
		player.is_big_jumping = false
		wall_coyote_counter = player.wall_coyote_time
	elif player.is_on_floor():
		player.is_big_jumping = false
	else:
		wall_coyote_counter -= delta

	if timer > 0:
		timer -= delta
	else: player.is_big_jumping = false

	if Input.is_action_just_pressed("finger"):
		finger_buffer_counter = player.jump_buffer_time
	else:
		finger_buffer_counter -= delta

	if finger_buffer_counter > 0:
		if wall_coyote_counter > 0.0 or player.is_on_wall():
			finger(player, player.wall_dir)

func finger(player, dir):
	player.is_big_jumping = true
	timer = player.finger_time

	var outward = player.finger_force.x * dir
	player.velocity.x = outward + (player.input_dir * 150) # input can help steer
	player.velocity.y = player.finger_force.y
