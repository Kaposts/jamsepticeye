extends Control
@onready var play_button: TextureButton = $Post/VBoxContainer/Play_Button
@onready var options_button: TextureButton = $Post/VBoxContainer/Options_Button
@onready var credits_button: TextureButton = $Post/VBoxContainer/Credits_Button
@onready var exit_button: TextureButton = $Post2/VBoxContainer/Quit_Button
@onready var options_menu = $Options

@onready var scroll_anim: AnimationPlayer = $Options/Scroll/AnimationPlayer
@onready var options_anim: AnimationPlayer = $Options/AnimationPlayer

func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
	
func _on_play_button_pressed() -> void:
	pass
	
func _on_options_button_pressed() -> void:
	scroll_anim.play("Scroll_Open")
	options_anim.play("Menu_Load")
	options_menu.show()
	
func _on_exit_button_pressed() -> void:
	pass
	
func _on_credits_button_pressed() -> void:
	pass
