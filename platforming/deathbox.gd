extends Area2D
var active: bool = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player') and active: 
		body.die()
		active = false
		modulate = modulate.darkened(0.6)