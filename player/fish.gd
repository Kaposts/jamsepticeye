extends RigidBody2D

@export var flop_force: Vector2 = Vector2(200, -400)
@export var rotation_speed: float = 5.0

var facing_dir: int = 1

func _ready():
	$Timer.start()

func _physics_process(delta) -> void:
	if Input.is_action_just_pressed("ui_accept") and get_contact_count() > 0:
		facing_dir *= -1
		apply_force(Vector2(flop_force.x * facing_dir, flop_force.y), Vector2(position.x -2, position.y ))


func _on_timer_timeout() -> void:
	SignalBus.sig_player_died.emit()
	queue_free()
