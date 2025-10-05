class_name PlayerManager
extends Node

@export var fish_scene: PackedScene
@export var player_scene: PackedScene

@export var unlocked_abilities := []
@export var ability_scenes: Array[AbilityData] = []

var death_counter: int = 0

var can_wall_jump: bool = false
var can_hover: bool = false
var can_push: bool = false

var camera

func _ready():
	SignalBus.sig_player_died.connect(_on_player_died)
	
	get_parent().add_child.call_deferred(fish_scene.instantiate())
	camera = get_tree().get_first_node_in_group("player_follow_camera")

func _input(event):
	if event.is_action_pressed("restart"):
		if get_tree().get_nodes_in_group('player').size() <= 0:
			var player = player_scene.instantiate()
			player.camera = camera
			apply_abilities(player)
			get_parent().add_child(player)
			SignalBus.player_spawned.emit()
	if event.is_action_pressed("die"):
		get_tree().get_first_node_in_group("player").die()

func evolve():
	match death_counter:
		1: add_ability(Enum.ABILITY.WALK)
		2: add_ability(Enum.ABILITY.JUMP)
		3: 
			add_ability(Enum.ABILITY.CLAW)
			can_push = true
		4: can_wall_jump = true
		5: can_hover = true
		6: add_ability(Enum.ABILITY.GRAPPLE)
		7: add_ability(Enum.ABILITY.FINGER)

func add_ability(ability: Enum.ABILITY):
	var scene

	for data: AbilityData in ability_scenes:
		if data.ability == ability:
			scene = data.scene
			break
	
	if !scene:
		push_warning("ability ",ability, " not founr")
		return

	# var ability_instance: Node = scene.instantiate()
	unlocked_abilities.append(scene)


func apply_abilities(player):
	for ability in unlocked_abilities:
		var scene = ability.instantiate()
		player.abilities.append(scene)
		player.add_child(scene)
	
	
	player.can_wall_jump = can_wall_jump
	player.can_hover = can_hover
	player.can_push = can_push


func _on_player_died():
	death_counter += 1
	evolve()
