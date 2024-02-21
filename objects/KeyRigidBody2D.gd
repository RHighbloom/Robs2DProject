extends RigidBody2D

signal add_key

@onready var audio_player : AudioStreamPlayer2D = get_child(0)

var frequency = 5
var amplitude = 15
var time = 0
	
func _physics_process(delta):
	time += delta;
	var movement = cos(time*frequency)*amplitude
	position.y += movement * delta


func _on_area_2d_body_entered(body):
	if (body.name.to_lower().contains("character")):
			add_key.emit()
			get_child(2).queue_free()
			audio_player.play()


func _on_audio_stream_player_2d_finished():
	queue_free()
