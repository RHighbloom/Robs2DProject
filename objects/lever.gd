extends RigidBody2D
@export var objectToToggle: Node2D

func _on_toggleable_toggle_item():
	# Convert basis to quaternion, keep in mind scale is lost
	objectToToggle.rotate(-1 * PI/2)
	
func _on_body_entered():
	pass
	
func _on_body_shape_entered():
	pass
