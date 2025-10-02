extends Ability

func apply(player, delta):

	if Input.is_action_just_pressed("finger") and player.is_on_wall():
		finger(player, player.wall_dir)

func finger(player, dir):
	var outward = player.finger_force.x * dir
	player.velocity.x = outward + (player.input_dir * 100) # input can help steer
	player.velocity.y = player.finger_force.y