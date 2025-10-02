extends Ability

func apply(player, delta):
	player.input_dir = Input.get_axis("ui_left", "ui_right")
	player.velocity.x = player.input_dir * player.speed
