extends Node
class_name Damageable

signal dying
signal onHit

@onready var animation_tree : AnimationTree = get_parent().get_child(4)
@onready var audio_player : AudioStreamPlayer2D = get_parent().get_child(5)
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

@export var health : float = 1

func hit(damage: int):
	health -= damage
	onHit.emit()
	
	if (health <= 0):
		dying.emit()
		audio_player.play()
		state_machine.travel("death")



func _on_animation_tree_animation_finished(_anim_name):
	if (_anim_name.contains("death")):
		get_parent().queue_free()
