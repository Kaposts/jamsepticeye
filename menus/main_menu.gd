class_name MainMenu
extends CanvasLayer
## Main Menu Script

@export var web_quit_screen: PackedScene

@onready var play_button: TextureButton = %PlayButton
@onready var options_button: TextureButton = %OptionsButton
@onready var credits_button: TextureButton = %CreditsButton
@onready var quit_button: TextureButton = %QuitButton
@onready var options_menu = $ControlRoot/Options
@onready var credits_menu = $ControlRoot/Credits

@onready var options_scroll_anim: AnimationPlayer = $ControlRoot/Options/Scroll/AnimationPlayer
@onready var options_anim: AnimationPlayer = $ControlRoot/Options/AnimationPlayer
@onready var credits_anim: AnimationPlayer =$ControlRoot/Credits/AnimationPlayer
@onready var credits_scroll_anim: AnimationPlayer = $ControlRoot/Credits/Scroll/AnimationPlayer

func _ready() -> void:
	get_tree().paused = true
	
	play_button.pressed.connect(_on_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_play_button_pressed() -> void:
	MusicPlayer.switch_song(Enum.SongNames.GAME_LOOP, true, true)
	hide()
	get_tree().paused = false
	SignalBus.sig_game_started.emit()


func _on_options_button_pressed() -> void:
	options_scroll_anim.play("Scroll_Open")
	options_anim.play("Menu_Load")
	options_menu.show()


func _on_quit_button_pressed() -> void:
	var platform_name: StringName = OS.get_name()
	match platform_name:
		"Windows":
			get_tree().quit()
		"Web":
			var quit_screen_instance: CanvasLayer = web_quit_screen.instantiate()
			add_child(quit_screen_instance)


func _on_credits_button_pressed() -> void:
	credits_scroll_anim.play("Scroll_Open")
	credits_anim.play("Menu_Load")
	credits_menu.show()
