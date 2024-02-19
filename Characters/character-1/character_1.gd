extends CharacterBody2D
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

const SPEED = 75.0
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

##Used to determine which animation to be playing -
enum STATE {IDLE, WALK, JUMP, ROLL, SLIDE, GETUP}
enum DIRECTION {LEFT, RIGHT}

var current_state = STATE.IDLE
var last_direction = DIRECTION.RIGHT


##Function


func set_last_direction(new_direction):
	if (new_direction > 0):
		last_direction = DIRECTION.RIGHT
	elif (new_direction < 0):
		last_direction = DIRECTION.LEFT

func set_current_state(new_state):
	if (new_state == current_state):
		return
	
	match(new_state):
		STATE.IDLE:
			if (last_direction == DIRECTION.LEFT):
				state_machine.travel("idle_left")
			else:
				state_machine.travel("idle_right")
		STATE.WALK:
			if (last_direction == DIRECTION.LEFT):
				state_machine.travel("walk_left")
			else:
				state_machine.travel("walk_right")
		STATE.JUMP:
			if (last_direction == DIRECTION.LEFT):
				state_machine.travel("jump_left")
			else:
				state_machine.travel("jump_right")
		STATE.SLIDE:
			if (last_direction == DIRECTION.LEFT):
				state_machine.travel("slide_left")
			else:
				state_machine.travel("slide_right")
		STATE.GETUP:
			if (last_direction == DIRECTION.LEFT):
				state_machine.travel("get_up_left")
			else:
				state_machine.travel("get_up_right")
	current_state = new_state

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	## Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		set_current_state(STATE.JUMP)
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("slide_button"):
		set_current_state(STATE.SLIDE)
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		set_last_direction(direction)
		if (current_state != STATE.SLIDE && current_state != STATE.GETUP):
			velocity.x = direction * SPEED
			if (velocity.y == 0):
				set_current_state(STATE.WALK)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/50.0)
	else:
		if (velocity.y == 0 && current_state != STATE.SLIDE && current_state != STATE.GETUP):
			set_current_state(STATE.IDLE)
			
		if (is_on_floor()):
			velocity.x = move_toward(velocity.x, 0, SPEED/10.0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/25.0)

	move_and_slide()
	#----------------------------------------------------------------------------------------

func _on_animation_tree_animation_finished(anim_name):
	if (anim_name.contains("slide")):
		set_current_state(STATE.GETUP)
	elif (anim_name.contains("get_up")):
		set_current_state(STATE.IDLE)
