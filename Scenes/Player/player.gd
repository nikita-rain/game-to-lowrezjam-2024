extends CharacterBody2D



enum {AIR, GROUND, HORIZONTAL, VERTICAL, FALLING, HOVERING, JUMPING, JUMPING_TIME, JUMPING_AVIABLE}

enum {MAX_SPEED = 0, ACCELERATION = 1, DECELERATION = 2}
var speed_dict = {
	AIR : {
		HORIZONTAL : [50, 100*60, 100*60],
		VERTICAL : [0, 0, 0],
		FALLING : [150, 50*60, 100*60],
		HOVERING : [-5, 100*60, 0],
		JUMPING : [150, 100*60, 100*60],
		JUMPING_TIME : [100, 200], #msec
		JUMPING_AVIABLE : false
	},
	GROUND : {
		HORIZONTAL : [50, 100*60, 100*60],
		VERTICAL : [0, 0, 0],
		FALLING : [0, 150*60, 150*60],
		HOVERING : [0, 100*60, 0],
		JUMPING : [150, 150*60, 150*60],
		JUMPING_TIME : [100, 1000],
		JUMPING_AVIABLE : true
	}
}

var location = AIR

var jump_last_pressed_time = 0
var floor_last_touched_time = 0
@export var jump_buffer_time_msec = 200
@export var coyote_time_msec = 50

@export var jump_max_count = 1
@export var jump_aviable_count = 1

var is_jumping = false
var jump_time = 0
var jump_start_time = 0
var is_hovering = false
var hover_time = 0
var hover_start_time = 0
var current_time = 0

func update_location():
	if is_on_floor():
		jump_aviable_count = jump_max_count
		floor_last_touched_time = current_time
		location = GROUND
	else:
		if current_time - floor_last_touched_time > coyote_time_msec:
			location = AIR

func falling(delta):
	#FALLING
	velocity.y = move_toward(velocity.y, 
		speed_dict[location][FALLING][MAX_SPEED],
		speed_dict[location][FALLING][ACCELERATION] * delta)

func moving(delta):
	#MOVING
	var direction = Input.get_axis("move_left","move_right")
	var move_type = DECELERATION
	if direction:
		move_type = ACCELERATION
	velocity.x = move_toward(velocity.x, 
		speed_dict[location][HORIZONTAL][MAX_SPEED] * direction, 
		speed_dict[location][HORIZONTAL][move_type] * delta)

func jumping_and_hovering(delta):
	#JUMPING
	if Input.is_action_just_pressed("move_jump"):
		jump_last_pressed_time = Time.get_ticks_msec()
	
	var jump_pressed:bool = (current_time-jump_last_pressed_time) < jump_buffer_time_msec
	var jump_aviable:bool = speed_dict[location][JUMPING_AVIABLE] and jump_aviable_count > 0 
	if jump_pressed and jump_aviable and !is_jumping: #and count jumps 
		jump_aviable_count -= 1
		is_jumping = true
		is_hovering = false
		jump_start_time = current_time
		jump_time = speed_dict[location][JUMPING_TIME][0]
	
	var jump_is_over:bool = (current_time - jump_start_time) > jump_time
	if jump_is_over and is_jumping:
		is_jumping = false
		is_hovering = true
		hover_time = speed_dict[location][JUMPING_TIME][1]
		hover_start_time = current_time
	
	if is_jumping:
		velocity.y = move_toward(velocity.y, -1 * speed_dict[location][JUMPING][MAX_SPEED], speed_dict[location][JUMPING][ACCELERATION] * delta)
	
	var hover_is_over:bool = (current_time - hover_start_time) > hover_time
	if hover_is_over and is_hovering:
		is_hovering = false
	
	if is_hovering:
		velocity.y = move_toward(velocity.y, speed_dict[location][HOVERING][MAX_SPEED], speed_dict[location][HOVERING][ACCELERATION] * delta)

func check_input_and_change_velocity(delta):
	update_location()
	falling(delta)
	moving(delta)
	jumping_and_hovering(delta)


func _physics_process(delta):
	current_time = Time.get_ticks_msec()
	check_input_and_change_velocity(delta)
	move_and_slide()
