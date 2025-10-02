extends Node2D

@export var run: PackedScene
@export var jump: PackedScene
@export var claw: PackedScene
@export var grappling_hook: PackedScene

var p = CharacterBody2D

func _ready():
	p = get_tree().get_first_node_in_group('player')

func _on_button_pressed() -> void:
	add_abbility(run, $CanvasLayer/Button)


func add_abbility(scene: PackedScene, button: Button):
	var ability = scene.instantiate()
	p.abilities.append(ability)
	p.add_child(ability)
	
	button.disabled = true


func _on_button_2_pressed() -> void:
	add_abbility(jump, $CanvasLayer/Button2)

func _on_button_3_pressed() -> void:
	add_abbility(claw, $CanvasLayer/Button3)


func _on_button_4_pressed() -> void:
	p.can_wall_jump = true


func _on_button_5_pressed() -> void:
	p.abilities = []


func _on_grappling_hook_button_pressed() -> void:
	add_abbility(grappling_hook, $CanvasLayer/GrapplingHookButton)
