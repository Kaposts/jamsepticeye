extends Control

@export var entry_scene: PackedScene

@onready var http := HTTPRequest.new()

var leaderboard_data: Array = []
var url: String
signal leaderboard_loaded

func _ready():
	add_child(http)
	url = EnvParser.parse("FIREBASE_URL") + EnvParser.parse("LEADERBOARD_PATH")

	load_leaderboard()
	SignalBus.sig_score_submitted.connect(load_leaderboard)

func load_leaderboard():
	http.request(url)
	http.request_completed.connect(_on_request_completed, CONNECT_ONE_SHOT)

func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		push_warning("Failed to load leaderboard: " + str(response_code))
		return

	for child in $Panel/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()

	var data = JSON.parse_string(body.get_string_from_utf8())
	if typeof(data) == TYPE_DICTIONARY:
		leaderboard_data.clear()
		for name in data.keys():
			leaderboard_data.append(data[name])
		leaderboard_data.sort_custom(func(a, b): return a.time < b.time)
		emit_signal("leaderboard_loaded")

		print("--- Leaderboard ---")
		for i in range(min(10, leaderboard_data.size())):
			var entry = leaderboard_data[i]
			print("%d. %s - %.2f s" % [i + 1, entry.name, entry.time])
			var entry_instance = entry_scene.instantiate()
			entry_instance.entry_name = entry.name
			entry_instance.score = entry.time
			$Panel/ScrollContainer/VBoxContainer.add_child(entry_instance)
