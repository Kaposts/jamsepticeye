extends Control

@onready var close_button: TextureButton = $Credits/CloseButton
@onready var scroll_anim: AnimationPlayer = $Scroll/AnimationPlayer
@onready var menu_anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)


func close() -> void:
	scroll_anim.play("Scroll_Close")
	menu_anim.play("Menu_Close")
	await get_tree().create_timer(1.0).timeout
	hide()


func _on_close_button_pressed() -> void:
	close()
