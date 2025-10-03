extends Node

@export var fish_scene: PackedScene
@export var player_scene: PackedScene

@export var unlocked_abilities := []
@export var ability_scenes: Array[AbilityData] = []

var death_counter: int = 0

var can_wall_jump: bool = false

func _ready():
	SignalBus.sig_player_died.connect(_on_player_died)

	
	get_parent().add_child(fish_scene.instantiate())

func _input(event):
	if event.is_action_pressed("restart"):
		if get_tree().get_nodes_in_group('player').size() <= 0:
			get_parent().add_child(player_scene.instantiate())
			apply_abilities()

func evolve():
	print("Unlocked ability: ", Enum.ABILITY.find_key(death_counter - 1))

	match death_counter:
		1,2,3: add_abbility(Enum.ABILITY.get(Enum.ABILITY.find_key(death_counter - 1)))
		4: can_wall_jump = true

func add_abbility(ability: Enum.ABILITY):
	var ability_instance: Node = ability_scenes[ability].scene.instantiate()
	unlocked_abilities.append(ability_instance)

func apply_abilities():
	var p = get_tree().get_first_node_in_group('player')
	p.abilities = unlocked_abilities
	p.can_wall_jump = can_wall_jump


func _on_player_died():
	death_counter += 1
	evolve()