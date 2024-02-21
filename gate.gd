extends StaticBody2D

signal useKey

@onready var audio_player : AudioStreamPlayer2D = get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	if (body.name.to_lower().contains("character")):
		var player_obj : Player = body
		if (player_obj.key_count > 0):
			useKey.emit()
			audio_player.play()





func _on_audio_stream_player_2d_finished():
	queue_free()
