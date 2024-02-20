extends Node
class_name Damageable

@onready var animation_tree = get_parent().get_child(4)
@onready var state_machine = animation_tree.get("parameters/playback")

@export var health : float = 1

func hit(damage: int):
	health -= damage
	
	if (health <= 0):
		state_machine.travel("shatter")



func _on_animation_tree_animation_finished(_anim_name):
	print("rip")
	get_parent().queue_free()
