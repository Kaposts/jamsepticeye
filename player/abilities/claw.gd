extends Ability

func apply(player, delta):
	var is_touching_wall = player.is_on_wall()

	if is_touching_wall:
		player.wall_dir = sign(player.get_wall_normal().x)

	if is_touching_wall and not player.is_on_floor() and player.velocity.y > 0:
		if player.velocity.y > player.wall_slide_speed:
			player.velocity.y = player.wall_slide_speed