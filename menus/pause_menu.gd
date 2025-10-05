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


func _on_close_button_pressed() -> void:
	scroll_anim.play("Scroll_Close")
	menu_anim.play("Menu_Close")
	await get_tree().create_timer(1.0).timeout
	hide()


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_quit_button_pressed() -> void:
	var platform_name: StringName = OS.get_name()
	match platform_name:
		"Windows":
			get_tree().quit()
		"Web":
			var quit_screen_instance: CanvasLayer = web_quit_screen.instantiate()
			add_child(quit_screen_instance)
