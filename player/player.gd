extends CharacterBody2D

@export var abilities: Array = []

@export var speed := 150
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_wall_jump: bool = false
var wall_dir = 0
var input_dir: float

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	for ability in abilities:
		ability.apply(self, delta)

	move_and_slide()
