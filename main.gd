extends Node2D


@export var run: PackedScene
@export var jump: PackedScene
@export var claw: PackedScene
@export var grapple: PackedScene

var player: CharacterBody2D

@onready var run_button: Button = %RunButton
@onready var jump_button: Button = %JumpButton
@onready var claw_button: Button = %ClawButton
@onready var wall_jump_button: Button = %WallJumpButton
@onready var grapple_button: Button = %GrappleButton
@onready var all_abilities_button: Button = %AllAbilitiesButton


func _ready() -> void:
	player = get_tree().get_first_node_in_group('player')
	
	run_button.pressed.connect(_on_run_button_pressed)
	jump_button.pressed.connect(_on_jump_button_pressed)
	claw_button.pressed.connect(_on_claw_button_pressed)
	wall_jump_button.pressed.connect(_on_wall_jump_button_pressed)
	grapple_button.pressed.connect(_on_grapple_button_pressed)
	
	all_abilities_button.pressed.connect(_on_all_abilities_button_pressed)


func add_ability(scene: PackedScene, button: Button):
	var ability = scene.instantiate()
	player.add_child(ability)
	player.abilities.append(ability)
	
	button.disabled = true


func _on_run_button_pressed() -> void:
	add_ability(run, run_button)


func _on_jump_button_pressed() -> void:
	add_ability(jump, jump_button)


func _on_claw_button_pressed() -> void:
	add_ability(claw, claw_button)


func _on_wall_jump_button_pressed() -> void:
	player.can_wall_jump = true
	wall_jump_button.disabled = true


func _on_grapple_button_pressed() -> void:
	add_ability(grapple, grapple_button)


func _on_button_5_pressed() -> void:
	player.abilities = []


func _on_all_abilities_button_pressed() -> void:
	_on_run_button_pressed()
	_on_jump_button_pressed()
	_on_claw_button_pressed()
	_on_wall_jump_button_pressed()
	_on_grapple_button_pressed()
	
	all_abilities_button.disabled = true                  
