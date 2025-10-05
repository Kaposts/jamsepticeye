extends Ability

func apply(player, delta):
	var input_direction = Input.get_axis("ui_left", "ui_right")
	player.input_dir = input_direction

	var speed = player.hover_move_speed if player.is_hovering else player.speed

	var target_vel_x = input_direction * speed
	
	if player.wall_jump_lock_counter > 0.0:
		target_vel_x = 0
		player.wall_jump_lock_counter -= delta


	if (!player.is_on_floor() or !player.is_on_wall()) and player.is_big_jumping == false:
		player.velocity.x = move_toward(player.velocity.x, target_vel_x, speed * delta * 100)
	else: player.velocity.x = move_toward(player.velocity.x, target_vel_x, player.acceleration * delta)
