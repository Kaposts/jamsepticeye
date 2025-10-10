class_name PauseMenu
extends Control

const ANIM_SPEED_MODIFIER: float = 4.0

@export var web_quit_screen: PackedScene

@onready var back_button: TextureButton = $PauseOptions/BackButton

@onready var scroll_anim: AnimationPlayer = $Scroll/AnimationPlayer
@onready var menu_anim: AnimationPlayer = $AnimationPlayer
@onready var options_scroll_anim: AnimationPlayer = $Options/Scroll/AnimationPlayer
@onready var options_anim: AnimationPlayer = $Options/AnimationPlayer

@onready var restart_button: TextureButton = $PauseOptions/VBoxContainer/Restart
@onready var options_button: TextureButton = $PauseOptions/VBoxContainer/Options
@onready var quit_button: TextureButton = $PauseOptions/VBoxContainer/Quit
@onready var tutorial_summary_button: SoundButton = $PauseOptions/TutorialSummaryButton

@onready var options_menu: Control = $Options
@onready var keybinds_settings: Control = $Options/Options/KeybindsSettings
@onready var tutorial_summary: Control = $TutorialSummary

var enabled: bool = false
var is_animating: bool = false


func _ready() -> void:
	hide()
	
	scroll_anim.speed_scale *= ANIM_SPEED_MODIFIER
	menu_anim.speed_scale *= ANIM_SPEED_MODIFIER
	options_scroll_anim.speed_scale *= ANIM_SPEED_MODIFIER
	options_anim.speed_scale *= ANIM_SPEED_MODIFIER
	
	back_button.pressed.connect(_on_back_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	tutorial_summary_button.pressed.connect(_on_tutorial_summary_pressed)
	
	scroll_anim.animation_finished.connect(close_finished)
	
	SignalBus.sig_game_restarted.connect(_on_game_restarted)
	SignalBus.sig_game_started.connect(_on_game_started)
	SignalBus.sig_pause_menu_requested.connect(_on_pause_menu_requested)


func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return
	
	if event.is_action_pressed("pause"):
		if keybinds_settings.visible:
			keybinds_settings.hide()
		elif tutorial_summary.visible:
			tutorial_summary.hide()
		elif options_menu.visible:
			if not options_menu.is_animating:
				options_menu.close()
		elif visible:
			if not is_animating:
				close()
		else:
			open()
	

func _on_back_button_pressed() -> void:
	if is_animating:
		return
	
	close()
	await get_tree().create_timer(1.0, false).timeout
	hide()
	SignalBus.sig_game_unpaused.emit()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	SignalBus.sig_game_unpaused.emit()


func _on_options_button_pressed() -> void:
	options_scroll_anim.play("Scroll_Open")
	options_anim.play("Menu_Load")
	options_menu.show()
	options_menu.is_animating = true
	
	await options_anim.animation_finished
	options_menu.enable_ui()
	options_menu.is_animating = false



func _on_quit_button_pressed() -> void:
	var platform_name: StringName = OS.get_name()
	match platform_name:
		"Web":
			var quit_screen_instance: CanvasLayer = web_quit_screen.instantiate()
			add_child(quit_screen_instance)
		_:
			get_tree().quit()


func close():
	scroll_anim.play("Scroll_Close")
	menu_anim.play("Menu_Close")
	is_animating = true


func close_finished(anim_name):
	if anim_name == 'Scroll_Close':
		is_animating = false
		SignalBus.sig_game_unpaused.emit()
		hide()


func open():
	is_animating = true
	SignalBus.sig_game_paused.emit()
	show()
	scroll_anim.play("Scroll_Open")
	menu_anim.play("Menu_Load")
	
	await menu_anim.animation_finished
	is_animating = false


func _on_game_restarted() -> void:
	enabled = false


func _on_game_started() -> void:
	enabled = true


func _on_tutorial_summary_pressed() -> void:
	tutorial_summary.visible = !tutorial_summary.visible


func _on_pause_menu_requested() -> void:
	if not visible:
		open()
