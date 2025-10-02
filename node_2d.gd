extends Node2D

@export var run: PackedScene
@export var jump: PackedScene
@export var claw: PackedScene

var p

func _ready():
	p = get_tree().get_first_node_in_group('player')

func _on_button_pressed() -> void:
	add_abbility(run)

func add_abbility(scene: PackedScene):
	var ability: Node = scene.instantiate()
	p.abilities.append(ability)

func _on_button_2_pressed() -> void:
	add_abbility(jump)

func _on_button_3_pressed() -> void:
	add_abbility(claw)


func _on_button_4_pressed() -> void:
	p.can_wall_jump = true


func _on_button_5_pressed() -> void:
	p.abilities = []
