extends Label


func _on_node_2d_time_updated(time: float) -> void:
	text = "%.2f" % time
