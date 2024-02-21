extends CharacterBody2D

@onready var animation_tree : AnimationTree = get_child(4)
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var vision_cast : RayCast2D = get_child(6)

var timeSinceLastCast: float = 0;
var timeSinceLastAttack: float = 0;
enum DIRECTION {LEFT, RIGHT}
var last_direction = DIRECTION.RIGHT

var target : Player = null
var speed : float = 25
var dying: bool = false

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
	timeSinceLastAttack += delta

func _physics_process(delta):
	if (!dying):
		if (target == null): 
			if (vision_cast.is_colliding()):
				if (vision_cast.get_collider().get_parent().name.to_lower().contains("character")):
					target = vision_cast.get_collider().get_parent()
				
			elif (timeSinceLastCast > 3):
				timeSinceLastCast = 0
				swap_direction()
				state_machine.travel("idle" + get_direction())
		else:
			if (timeSinceLastAttack > 2.5):
				timeSinceLastAttack = 0
				state_machine.travel("attack_left")
			else:
				state_machine.travel("idle_left")

func _on_gate_static_body_use_key():
	animation_tree.active = true
	state_machine.travel("dead_alive")


func _on_damageable_dying():
	dying = true
	for _i in self.get_children():
		if (_i is CollisionShape2D):
			_i.disabled = true


func _on_damageable_on_hit():
	state_machine.travel("hurt_left")
