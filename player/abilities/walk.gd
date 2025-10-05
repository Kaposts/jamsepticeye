extends Ability

func apply(player, delta):
	var input_direction = Input.get_axis("ui_left", "ui_right")
	player.input_dir = input_direction

	var speed = player.hover_move_speed if player.is_hovering else player.speed

	var target_vel_x = input_direction * speed
	if player.is_big_jumping:
		target_vel_x = 0


	if !player.is_on_floor() and !player.is_big_jumping:
		player.velocity.x = move_toward(player.velocity.x, target_vel_x, speed * delta * 100)
	# elif player.is_big_jumping:
	# 	player.velocity.x = move_toward(player.velocity.x, target_vel_x, player.acceleration * delta)
	else: player.velocity.x = move_toward(player.velocity.x, target_vel_x, player.acceleration * delta)
