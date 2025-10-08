class_name MainMenu
extends CanvasLayer
## Main Menu Script

@export var web_quit_screen: PackedScene

@onready var play_button: TextureButton = %PlayButton
@onready var options_button: TextureButton = %OptionsButton
@onready var credits_button: TextureButton = %CreditsButton
@onready var quit_button: TextureButton = %QuitButton
@onready var leaderboard_button: Button = %LeaderboardButton

@onready var options_menu = %Options
@onready var credits_menu = %Credits
@onready var leaderboard_window: Control = %LeaderboardWindow
@onready var keybinds_settings: Control = options_menu.get_node("Options/KeybindsSettings")

@onready var options_scroll_anim: AnimationPlayer = options_menu.get_node("Scroll/AnimationPlayer")
@onready var options_anim: AnimationPlayer = options_menu.get_node("AnimationPlayer")
@onready var credits_anim: AnimationPlayer = credits_menu.get_node("AnimationPlayer")
@onready var credits_scroll_anim: AnimationPlayer = credits_menu.get_node("Scroll/AnimationPlayer")

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	leaderboard_button.pressed.connect(_on_leaderboard_button_pressed)
	
	SignalBus.sig_game_restarted.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not visible:
			return
		if keybinds_settings.visible:
			keybinds_settings.hide()
		elif credits_menu.visible:
			credits_menu.close()
		elif options_menu.visible:
			options_menu.close()
		elif leaderboard_window.visible:
			leaderboard_window.hide()


func _on_play_button_pressed() -> void:
	MusicPlayer.switch_song(Enum.SongNames.GAME_LOOP, true, true)
	SignalBus.sig_game_started.emit()
	
	_disable_all_buttons()
	leaderboard_window.hide()
	
	animation_player.play("game_start")
	await animation_player.animation_finished
	
	hide()


func _enable_all_buttons() -> void:
	play_button.disabled = false
	options_button.disabled = false
	credits_button.disabled = false
	quit_button.disabled = false


func _disable_all_buttons() -> void:
	play_button.disabled = true
	options_button.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	leaderboard_button.disabled = true


func _on_options_button_pressed() -> void:
	options_scroll_anim.play("Scroll_Open")
	options_anim.play("Menu_Load")
	options_menu.show()
	options_menu.is_animating = true
	
	await options_anim.animation_finished
	options_menu.enable_ui()
	options_menu.is_animating = false
	leaderboard_window.hide()


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
	leaderboard_window.hide()


func _on_leaderboard_button_pressed() -> void:
	if leaderboard_window.visible:leaderboard_window.hide()
	else: 
		leaderboard_window.show()
		leaderboard_window.load_leaderboard()
