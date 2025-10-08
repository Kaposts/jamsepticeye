extends Area2D
var active: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var death_icon_sprite: AnimatedSprite2D = $DeathIconSprite
@onready var death_icon_sprite_material: ShaderMaterial = death_icon_sprite.material


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player') and active: 
		body.die()
		active = false
		modulate = modulate.darkened(0.6)
		animation_player.stop()
		death_icon_sprite.stop()
		death_icon_sprite_material.set_shader_parameter("died", true)
