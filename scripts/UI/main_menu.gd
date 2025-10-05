extends Control
@onready var play_button: TextureButton = $Main_Menu/Post/VBoxContainer/Play_Button
@onready var options_button: TextureButton = $Main_Menu/Post/VBoxContainer/Options_Button
@onready var credits_button: TextureButton = $Main_Menu/Post/VBoxContainer/Credits_Button
@onready var exit_button: TextureButton = $Main_Menu/Post2/VBoxContainer/Quit_Button
@onready var options_menu = $Options
@onready var credits_menu = $credits
@onready var main_menu = $Main_Menu

@onready var options_scroll_anim: AnimationPlayer = $Options/Scroll/AnimationPlayer
@onready var options_anim: AnimationPlayer = $Options/AnimationPlayer
@onready var credits_anim: AnimationPlayer = $credits/AnimationPlayer
@onready var credits_scroll_anim: AnimationPlayer = $credits/Scroll/AnimationPlayer

func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
	
func _on_play_button_pressed() -> void:
	pass
	
func _on_options_button_pressed() -> void:
	options_scroll_anim.play("Scroll_Open")
	options_anim.play("Menu_Load")
	options_menu.show()
	
func _on_exit_button_pressed() -> void:
	pass
	
func _on_credits_button_pressed() -> void:
	credits_scroll_anim.play("Scroll_Open")
	credits_anim.play("Menu_Load")
	credits_menu.show()
