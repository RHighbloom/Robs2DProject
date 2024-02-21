extends RichTextLabel

var count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_text()
	
func update_text():
		text = "Keys: " + str(count)

func _on_key_rigid_body_2d_add_key():
	count += 1
	update_text()
