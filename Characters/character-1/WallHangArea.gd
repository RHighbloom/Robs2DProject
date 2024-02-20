extends Area2D


func _ready():
	monitoring = false


func _on_body_entered(body):
	print(body.name)
	for child in body.get_children():
		print (child.name)

