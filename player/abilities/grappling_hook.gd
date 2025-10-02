extends Ability
## Grappling Hook Ability to simulate tongue (frog-like creature)

@onready var ray: RayCast2D = $RayCast2D

var launched: bool = false
var target: Vector2 = Vector2.ZERO


func apply(player: Node, delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("launch_grappling_hook"):
		launch()
	elif event.is_action_released("launch_grappling_hook"):
		retract()


func launch() -> void:
	if ray.is_colliding():
		launched = true
		ray.get_collision_point()


func retract() -> void:
	launched = false
