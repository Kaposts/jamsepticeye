class_name GrappleSystemFactory
extends RefCounted

const GRAPPLE_SYSTEM_SCENE: PackedScene = preload("uid://dmqlbblw0cmwt")


static func new_grapple(root_node: Node2D,
						grapple_anchor_position: Vector2,
						player_anchor_position: Vector2) -> GrappleSystem:
	var new_grapple_system: GrappleSystem = GRAPPLE_SYSTEM_SCENE.instantiate()
	root_node.add_child(new_grapple_system)
	new_grapple_system.grapple_anchor.global_position = grapple_anchor_position
	new_grapple_system.player_anchor.global_position = player_anchor_position
	
	return new_grapple_system
