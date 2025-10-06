extends RigidBody2D

@export var flop_force: Vector2 = Vector2(200, -400)
@export var rotation_speed: float = 5.0
@export var flop_count_to_death: int = 5

@export var dead_fish_texture: Texture2D

var can_die: bool = false
var flopping: bool = false
var dying: bool = false
var facing_dir: int = 1
var current_flop_count: int = 0:
	set(value):
		current_flop_count = value
		check_death()

@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_material: ShaderMaterial = sprite.material
@onready var die_sfx_player: RandomAudioPlayer2D = $SFX/DieSFXPlayer
@onready var flop_sfx_player: RandomAudioPlayer2D = $SFX/FlopSFXPlayer


func _ready() -> void:
	sleeping_state_changed.connect(_on_sleeping_state_changed)
	SignalBus.sig_game_started.connect(_on_game_started)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and not flopping and not dying:
		facing_dir *= -1
		apply_impulse(Vector2(flop_force.x * facing_dir, flop_force.y), Vector2(position.x -2, position.y ))
		flop_sfx_player.play_random()


func _physics_process(_delta: float) -> void:
	if not flopping and get_contact_count() == 0:
		flopping = true
	
	elif flopping and get_contact_count() > 0:
			flopping = false
			if can_die:
				current_flop_count += 1


func check_death() -> void:
	if current_flop_count >= flop_count_to_death:
		dying = true


func _on_sleeping_state_changed() -> void:
	if sleeping and dying:
		SignalBus.sig_player_died.emit()
		_leave_corpse()
		die_sfx_player.play_random()
		
		await die_sfx_player.finished
		queue_free()


## Leave a sprite of the body in the scene
func _leave_corpse() -> void:
	sprite.texture = dead_fish_texture
	sprite_material.set_shader_parameter("died", true)
	sprite.reparent(get_parent())


func _on_game_started() -> void:
	can_die = true
