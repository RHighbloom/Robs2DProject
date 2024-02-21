extends Node
class_name Toggleable

signal toggle_item

@onready var animation_tree = get_parent().get_child(4)
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var audio_player = get_parent().get_child(5)

func hit():
	state_machine.travel("toggle")
	audio_player.play()
	toggle_item.emit()
