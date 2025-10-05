extends Control

@onready var close_button: TextureButton = $Options/Back_Button
@onready var scroll_anim: AnimationPlayer = $Scroll/AnimationPlayer
@onready var menu_anim: AnimationPlayer = $AnimationPlayer
@onready var keybinding_button : TextureButton = $Options/KeyBindings

func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)
	keybinding_button.pressed.connect(_on_keybinding_button_pressed)
	
	
func _on_close_button_pressed() -> void:
	scroll_anim.play("Scroll_Close")
	menu_anim.play("Menu_Close")
	await get_tree().create_timer(1.0).timeout
	hide()

func _on_keybinding_button_pressed() -> void:
	pass
