extends Area2D

@export var damage: int = 3

func _ready():
	monitoring = false

func _on_body_entered(body):
	print(body.name)
	for child in body.get_children():
		print(child.name)
		if (child is Damageable):
			child.hit(damage)
		if (child is Toggleable):
			child.hit()
