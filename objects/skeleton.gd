extends RigidBody2D

@onready var animation_tree : AnimationTree = get_child(4)
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var vision_cast : RayCast2D = get_child(6)

var timeSinceLastCast: float = 0;
enum DIRECTION {LEFT, RIGHT}
var last_direction = DIRECTION.RIGHT

var target : Player = null
var speed : float = 25

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
	pass

func _process(delta):
	timeSinceLastCast += delta

func _physics_process(delta):
	if (vision_cast.is_colliding()):
		print(vision_cast.get_collider().name)
		print(vision_cast.get_collider().get_parent())
	

func start_attack():
	print("attacking left")
	state_machine.travel("attack_left")
	
func _on_gate_static_body_use_key():
	animation_tree.active = true
