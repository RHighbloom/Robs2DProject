extends CharacterBody2D
class_name Player

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var audio_player : AudioStreamPlayer2D = get_child(5)


const SPEED = 75.0
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


##Used to determine which animation to be playing -
enum STATE {IDLE, WALK, JUMP, ROLL, SLIDE, GETUP, ATTACK, WALLHANG, FALL}
enum DIRECTION {LEFT, RIGHT}

var current_state = STATE.IDLE
var last_direction = DIRECTION.RIGHT

var key_count = 0

##Function

func get_state_priority(state):
	var priority = 1
	match(state):
		STATE.ATTACK, STATE.WALLHANG:
			priority = 100
		STATE.GETUP, STATE.SLIDE:
			priority = 50
	return priority

func compare_state_priority(state1, state2):
	return get_state_priority(state1) > get_state_priority(state2)

func set_last_direction(new_direction):
	if (new_direction > 0):
		last_direction = DIRECTION.RIGHT
	elif (new_direction < 0):
		last_direction = DIRECTION.LEFT

func set_current_state(new_state):
	if (new_state == current_state):
		return
	
	const _left : String = "_left"
	const _right: String = "_right"
	
	var animationString = ""
	var directionString =  _left if last_direction == DIRECTION.LEFT else _right
	
	match(new_state):
		STATE.IDLE:
			animationString = "idle"
		STATE.WALK:
			animationString = "walk"
		STATE.JUMP:
			animationString = "jump"
		STATE.SLIDE:
			animationString = "slide"
		STATE.GETUP:
			animationString = "get_up"
		STATE.ATTACK:
			animationString = "attack"
		STATE.WALLHANG:
			animationString = "wall_hang"
		STATE.FALL:
			animationString = "fall"
	
	state_machine.travel(animationString + directionString)
	current_state = new_state

func _physics_process(delta):
	#add gravity
	add_gravity(delta)
	
	## Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		set_current_state(STATE.JUMP)
		velocity.y = JUMP_VELOCITY
		
	if (Input.is_action_just_pressed("attack_button")):
		set_current_state(STATE.ATTACK)
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		if Input.is_action_just_pressed("slide_button"):
			set_last_direction(direction)
			velocity.x = direction * (SPEED + 50)
			set_current_state(STATE.SLIDE)
		
		else:
			if (!compare_state_priority(current_state, STATE.WALK)):
				check_for_walking(direction)
			elif(current_state == STATE.WALLHANG):
				wallhang_transition(direction)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED/50.0)
	else:
		check_for_friction()

	move_and_slide()
#----------------------------------------------------------------------------------------

func add_gravity(delta):
	if (not is_on_floor()):
		velocity.y += gravity * delta
	if (velocity.y > 0 && !compare_state_priority(current_state, STATE.FALL)):
		set_current_state(STATE.FALL)
		

func wallhang_transition(direction: int):
	if ((direction < 0 && last_direction == DIRECTION.LEFT) ||
		(direction > 0 && last_direction == DIRECTION.RIGHT)):

			print("Should Climb")
	else:
		set_last_direction(direction)
		velocity.x = direction * SPEED
		set_current_state(STATE.FALL)
		print("Should fall")

func check_for_walking(direction):
	set_last_direction(direction)
	velocity.x = direction * SPEED
	if (velocity.y == 0):
		set_current_state(STATE.WALK)

func check_for_friction():
	if (velocity.y == 0 && !compare_state_priority(current_state, STATE.WALK)):
		set_current_state(STATE.IDLE)
			
		if (is_on_floor()):
			velocity.x = move_toward(velocity.x, 0, SPEED/10.0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/25.0)


func _on_animation_tree_animation_finished(anim_name):
	if (anim_name.contains("slide")):
		set_current_state(STATE.GETUP)
	elif (anim_name.contains("get_up")):
		set_current_state(STATE.IDLE)
	elif (anim_name.contains("attack")):
		set_current_state(STATE.IDLE)
	elif (anim_name.contains("jump")):
		set_current_state(STATE.FALL)
	elif (anim_name.contains("hang")):
		set_current_state(STATE.IDLE)


func _on_key_rigid_body_2d_add_key():
	key_count += 1


func _on_gate_static_body_use_key():
	key_count -= 1
