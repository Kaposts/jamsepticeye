extends Node


@onready var http := HTTPRequest.new()
var url

func _ready():
	url = EnvParser.parse("FIREBASE_URL") + EnvParser.parse("LEADERBOARD_PATH")
	add_child(http)

# --- Upload a new score ---
func add_score(name: String, time: float) -> void:
	var data = {
		"name": name,
		"time": time,
		"timestamp": Time.get_unix_time_from_system()
	}
	var json = JSON.stringify(data)
    
	http.request(url, [], HTTPClient.METHOD_POST, json)

func get_leaderboard(callback: Callable) -> void:
	http.request(url, [], HTTPClient.METHOD_GET)
	http.request_completed.connect(func(result, response_code, headers, body):
		if response_code == 200:
			var json = JSON.parse_string(body.get_string_from_utf8())
			if json:
				var scores = json.values()
				scores.sort_custom(func(a, b): return a.time < b.time)
				callback.call(scores)
	)
