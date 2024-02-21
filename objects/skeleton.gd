extends RigidBody2D

@onready var animation_tree : AnimationTree = get_child(4)
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var vision_cast : RayCast2D = get_child(6)

var timeSinceLastCast: float = 0;
enum DIRECTION {LEFT, RIGHT}
var last_direction = DIRECTION.RIGHT

func get_direction():
	const _left : String = "_left"
	const _right: String = "_right"
	
	var directionString =  _left if last_direction == DIRECTION.LEFT else _right
	return directionString


func swap_direction():
	if (last_direction == DIRECTION.RIGHT):
		last_direction = DIRECTION.LEFT
	else:
		last_direction = DIRECTION.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	timeSinceLastCast += delta
	
	if (timeSinceLastCast > 3):
		state_machine.travel("idle" + get_direction())
		swap_direction()
		vision_cast.enabled = true
		timeSinceLastCast = 0


		if (vision_cast.is_colliding()):
			var playerArea: Area2D = vision_cast.get_collider()
			var player : Player = playerArea.get_parent()
			print(player.name)
			move_to_position()
			
func move_to_position():
	
	pass
	

func _on_gate_static_body_use_key():
	animation_tree.active = true
