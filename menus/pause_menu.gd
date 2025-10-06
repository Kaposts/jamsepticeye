extends Control

@export var main_menu_scene: PackedScene
@export var web_quit_screen: PackedScene

@onready var close_button: TextureButton = $Pause_Options/Back_Button
@onready var scroll_anim: AnimationPlayer = $Scroll/AnimationPlayer
@onready var menu_anim: AnimationPlayer = $AnimationPlayer
@onready var options_scroll_anim: AnimationPlayer = $Options/Scroll/AnimationPlayer
@onready var options_anim: AnimationPlayer = $Options/AnimationPlayer

# @onready var main_menu_button: TextureButton = $Pause_Options/VBoxContainer/MainMenu
@onready var options_button: TextureButton = $Pause_Options/VBoxContainer/Options
@onready var quit_button: TextureButton = $Pause_Options/VBoxContainer/Quit

@onready var options_menu: Control = $Options
@onready var keybinds_settings: Control = $Options/Options/KeybindsSettings

var enabled: bool = false
var is_animating: bool = false


func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)
	# main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	scroll_anim.animation_finished.connect(close_finished)
	
	SignalBus.sig_game_restarted.connect(_on_game_restarted)
	SignalBus.sig_game_started.connect(_on_game_started)


func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return
	
	if event.is_action_pressed("pause"):
		if keybinds_settings.visible:
			keybinds_settings.hide()
		elif options_menu.visible:
			if not options_menu.is_animating:
				options_menu.close()
		elif visible:
			if not is_animating:
				close()
		else:
			open()
	

func _on_close_button_pressed() -> void:
	close()
	await get_tree().create_timer(1.0).timeout
	hide()
	SignalBus.sig_game_unpaused.emit()


func _on_main_menu_button_pressed() -> void:
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
		"Windows":
			get_tree().quit()
		"Web":
			var quit_screen_instance: CanvasLayer = web_quit_screen.instantiate()
			add_child(quit_screen_instance)


func close():
	scroll_anim.play("Scroll_Close")
	menu_anim.play("Menu_Close")

func close_finished(anim_name):
	if anim_name == 'Scroll_Close':
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
