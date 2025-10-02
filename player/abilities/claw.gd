extends Ability

@export var wall_slide_speed: float = 80.0

func apply(player, delta):
	# --- Wall Check ---
	var is_touching_wall = player.is_on_wall()

	if is_touching_wall:
		player.wall_dir = sign(player.get_wall_normal().x)

	# --- Wall Slide ---
	if is_touching_wall and not player.is_on_floor() and player.velocity.y > 0:
		if player.velocity.y > wall_slide_speed:
			player.velocity.y = wall_slide_speed
