extends RigidBody2D

@export var max_speed: float = 250.0    # how fast block can be pushed
@export var friction: float = 8.0       # how quickly it slows down

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Limit speed so block doesn’t fly off
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

	# Apply simple friction
	if linear_velocity.length() > 0.1:
		var friction_force = -linear_velocity.normalized() * friction
		apply_central_force(friction_force)
