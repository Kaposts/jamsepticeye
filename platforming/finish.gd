extends Area2D


func _on_body_entered(body: Node2D) -> void:
	SignalBus.sig_level_finished.emit()
