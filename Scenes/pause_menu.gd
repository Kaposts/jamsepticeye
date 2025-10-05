extends Control

@onready var close_button: TextureButton = $Pause_Options/Back_Button
@onready var scroll_anim: AnimationPlayer = $Scroll/AnimationPlayer
@onready var menu_anim: AnimationPlayer = $AnimationPlayer

@onready var main_menu_button: TextureButton = $Pause_Options/VBoxContainer/Main_Menu
@onready var options_button: TextureButton = $Pause_Options/VBoxContainer/Options
@onready var quit_button: TextureButton = $Pause_Options/VBoxContainer/Quit
func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)
	main_menu_button.pressed.connect(_on_mainmenu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
func _on_close_button_pressed() -> void:
	scroll_anim.play("Scroll_Close")
	menu_anim.play("Menu_Close")
	await get_tree().create_timer(1.0).timeout
	hide()
	
func _on_mainmenu_button_pressed() -> void:
	pass
	
func _on_quit_button_pressed() -> void:
	pass
