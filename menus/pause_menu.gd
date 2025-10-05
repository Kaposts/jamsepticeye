extends Control

@export var main_menu_scene: PackedScene
@export var web_quit_screen: PackedScene

@onready var close_button: TextureButton = $Pause_Options/Back_Button
@onready var scroll_anim: AnimationPlayer = $Scroll/AnimationPlayer
@onready var menu_anim: AnimationPlayer = $AnimationPlayer

@onready var main_menu_button: TextureButton = $Pause_Options/VBoxContainer/MainMenu
@onready var options_button: TextureButton = $Pause_Options/VBoxContainer/Options
@onready var quit_button: TextureButton = $Pause_Options/VBoxContainer/Quit


func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	scroll_anim.animation_finished.connect(close_finished)




func _input(event):
	if event.is_action_pressed("pause"):
		if visible:
			close()
		else:
			open()
	

func _on_close_button_pressed() -> void:
	close()
	await get_tree().create_timer(1.0).timeout
	hide()
	SignalBus.sig_game_unpaused.emit()


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
	SignalBus.sig_game_unpaused.emit()


func _on_quit_button_pressed() -> void:
	get_tree().reload_current_scene()
	SignalBus.sig_game_unpaused.emit()


func close():
	scroll_anim.play("Scroll_Close")
	menu_anim.play("Menu_Close")

func close_finished(anim_name):
	if anim_name == 'Scroll_Close':
		SignalBus.sig_game_unpaused.emit()
		hide()

func open():
	SignalBus.sig_game_paused.emit()
	show()
	scroll_anim.play("Scroll_Open")
	menu_anim.play("Menu_Load")
	# var platform_name: StringName = OS.get_name()
	# match platform_name:
	# 	"Windows":
	# 		get_tree().quit()
	# 	"Web":
	# 		var quit_screen_instance: CanvasLayer = web_quit_screen.instantiate()
	# 		add_child(quit_screen_instance)
