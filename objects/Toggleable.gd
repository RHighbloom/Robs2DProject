extends Node
class_name Toggleable

signal toggle_item

@onready var animation_tree = get_parent().get_child(4)
@onready var state_machine = animation_tree.get("parameters/playback")

func hit():
	print("toggled")
	state_machine.travel("toggle")
	toggle_item.emit()
