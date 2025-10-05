class_name GrapplePoint
extends StaticBody2D
## Grapple Point (Fly) Script

var in_range: bool = false:
	set(flag):
		in_range = flag
		_set_animation()
var attached: bool = false:
	set(flag):
		attached = flag
		_set_animation()

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	await get_tree().create_timer(randf_range(0.0, 0.5), false).timeout
	animation_player.play("default")


func _set_animation() -> void:
	if attached:
		animated_sprite.play("attached")
		animation_player.play("attached")
	elif in_range:
		animated_sprite.play("in_range")
		animation_player.play("default")
	else:
		animated_sprite.play("default")
		animation_player.play("default")
