extends Label


func _on_node_2d_time_updated(time: float) -> void:
	var minutes = int(time / 60)
	var seconds = fmod(time, 60.0)
	text = "%02d:%05.2f" % [minutes, seconds]
