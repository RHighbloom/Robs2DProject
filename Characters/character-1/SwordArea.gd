extends Area2D

@export var damage: int = 10

func _ready():
	monitoring = false


func _on_body_entered(body):
	print("body: " + body.name)
	
	for child in body.get_children():
		if (child is Damageable):
			child.hit(damage)
			print_debug(body.name + " took " + str(damage))
		if (child is Toggleable):
			child.hit()
			print_debug(body.name + " was toggled.")
