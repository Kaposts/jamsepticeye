class_name DebugWindow
extends CanvasLayer

@export var player_manager: PlayerManager

@export var run: PackedScene
@export var jump: PackedScene
@export var claw: PackedScene
@export var finger: PackedScene
@export var grapple: PackedScene

var player: CharacterBody2D

@onready var run_button: Button = %RunButton
@onready var jump_button: Button = %JumpButton
@onready var claw_button: Button = %ClawButton
@onready var wall_jump_button: Button = %WallJumpButton
@onready var grapple_button: Button = %GrappleButton
@onready var finger_button: Button = %FingerButton
@onready var get_all_button: Button = %GetAllButton
@onready var reset_button: Button = %ResetButton
@onready var hover_button: Button = %HoverButton


func _ready() -> void:
	player = get_tree().get_first_node_in_group('player')
	
	run_button.pressed.connect(_on_run_button_pressed)
	jump_button.pressed.connect(_on_jump_button_pressed)
	claw_button.pressed.connect(_on_claw_button_pressed)
	wall_jump_button.pressed.connect(_on_wall_jump_button_pressed)
	grapple_button.pressed.connect(_on_grapple_button_pressed)
	finger_button.pressed.connect(_on_finger_button_pressed)
	get_all_button.pressed.connect(_on_get_all_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)
	hover_button.pressed.connect(_on_hover_button_pressed)


func add_ability(scene: PackedScene, button: Button):
	player = get_tree().get_first_node_in_group('player')
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
	player.can_push = true

func _on_wall_jump_button_pressed() -> void:
	player.can_wall_jump = true
	wall_jump_button.disabled = true

func _on_grapple_button_pressed() -> void:
	add_ability(grapple, grapple_button)

func _on_finger_button_pressed() -> void:
	add_ability(finger, finger_button)

func _on_hover_button_pressed() -> void:
	player.can_hover = true
	hover_button.disabled = true

func _on_reset_button_pressed() -> void:
	player = get_tree().get_first_node_in_group('player')
	player.abilities = []
	_reset_buttons()

func _on_get_all_button_pressed() -> void:
	_on_run_button_pressed() 
	_on_jump_button_pressed()
	_on_claw_button_pressed() 
	_on_wall_jump_button_pressed()
	_on_grapple_button_pressed()
	_on_finger_button_pressed()
	_on_hover_button_pressed()


func _reset_buttons() -> void:
	run_button.disabled = false
	jump_button.disabled = false
	claw_button.disabled = false
	wall_jump_button.disabled = false
	grapple_button.disabled = false
	finger_button.disabled = false
	hover_button.disabled = false
