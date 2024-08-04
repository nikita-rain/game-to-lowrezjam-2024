extends CharacterBody2D

signal switch_shape() #TODO: добавить включение конкретной фигуры через меню
signal switch_color()
signal open_menu(menu: GameManager.menu_names) #TODO: добавить enum для менюшек в глобальном скрипте и вызывать его

enum {AIR, GROUND, HORIZONTAL, VERTICAL, FALLING, HOVERING, JUMPING, JUMPING_TIME, JUMPING_AVIABLE}
enum {MAX_SPEED = 0, ACCELERATION = 1, DECELERATION = 2}

var speed_dict = {
	ShapeData.shape_names.SQUARE_SMALL : {
		AIR : {
			HORIZONTAL : [50, 100*60, 100*60],
			VERTICAL : [0, 0, 0],
			FALLING : [300, 50*60, 100*60],
			HOVERING : [-10, 100*60, 0],
			JUMPING : [300, 100*60, 100*60],
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
	},
	ShapeData.shape_names.SQUARE : {
		AIR : {
			HORIZONTAL : [50, 100*60, 100*60],
			VERTICAL : [0, 0, 0],
			FALLING : [300, 50*60, 100*60],
			HOVERING : [-10, 100*60, 0],
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
	},
	ShapeData.shape_names.SQUARE_BIG : {
		AIR : {
			HORIZONTAL : [50, 100*60, 100*60],
			VERTICAL : [0, 0, 0],
			FALLING : [300, 50*60, 100*60],
			HOVERING : [-10, 100*60, 0],
			JUMPING : [150, 100*60, 100*60],
			JUMPING_TIME : [50, 200], #msec
			JUMPING_AVIABLE : false
		},
		GROUND : {
			HORIZONTAL : [50, 100*60, 100*60],
			VERTICAL : [0, 0, 0],
			FALLING : [0, 150*60, 150*60],
			HOVERING : [0, 100*60, 0],
			JUMPING : [150, 150*60, 150*60],
			JUMPING_TIME : [50, 1000],
			JUMPING_AVIABLE : true
		}
	},
	ShapeData.shape_names.CIRCLE : {
		AIR : {
			HORIZONTAL : [50, 100*60, 100*60],
			VERTICAL : [0, 0, 0],
			FALLING : [300, 50*60, 100*60],
			HOVERING : [-10, 100*60, 0],
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
	},
	ShapeData.shape_names.TRIANGLE_UP : {
		AIR : {
			HORIZONTAL : [50, 100*60, 100*60],
			VERTICAL : [0, 0, 0],
			FALLING : [300, 50*60, 100*60],
			HOVERING : [-10, 100*60, 0],
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
	},
	ShapeData.shape_names.TRIANGLE_DOWN : {
		AIR : {
			HORIZONTAL : [50, 100*60, 100*60],
			VERTICAL : [0, 0, 0],
			FALLING : [300, 50*60, 100*60],
			HOVERING : [-10, 100*60, 0],
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
	},
	ShapeData.shape_names.TETRIS : {
		AIR : {
			HORIZONTAL : [50, 100*60, 100*60],
			VERTICAL : [0, 0, 0],
			FALLING : [300, 50*60, 100*60],
			HOVERING : [-10, 100*60, 0],
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
	},
	ShapeData.shape_names.CROWN : {
		AIR : {
			HORIZONTAL : [50, 100*60, 100*60],
			VERTICAL : [0, 0, 0],
			FALLING : [300, 50*60, 100*60],
			HOVERING : [-10, 100*60, 0],
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
	},
}


var location = AIR
var gravity_state = 1

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


func _ready():
	shape_name_current =  $ShapeManager.get_curr_shape_name()

func update_location():
	if is_on_floor():
		jump_aviable_count = jump_max_count
		floor_last_touched_time = current_time
		location = GROUND
		fall_fast_down(false)
		ability_aviable = true
	else:
		if current_time - floor_last_touched_time > coyote_time_msec:
			location = AIR

func falling(delta):
	#FALLING
	if !is_jumping and !is_hovering:
		velocity.y = move_toward(velocity.y, 
			speed_dict[shape_name_current][location][FALLING][MAX_SPEED] * gravity_state,
			speed_dict[shape_name_current][location][FALLING][ACCELERATION] * delta)

func moving(delta):
	#MOVING
	var direction = Input.get_axis("move_left","move_right")
	var move_type = DECELERATION
	if direction:
		move_type = ACCELERATION
	velocity.x = move_toward(velocity.x, 
		speed_dict[shape_name_current][location][HORIZONTAL][MAX_SPEED] * direction, 
		speed_dict[shape_name_current][location][HORIZONTAL][move_type] * delta)

func jumping_and_hovering(delta):
	#JUMPING
	var jump_aviable:bool = (
		(speed_dict[shape_name_current][location][JUMPING_AVIABLE] or jump_max_count > 1) 
		and jump_aviable_count > 0
		)
	
	if Input.is_action_just_pressed("move_jump"):
		var ability_used = false
		if !jump_aviable:
			ability_used = ability_after_jump()
		if !ability_used:
			jump_last_pressed_time = Time.get_ticks_msec()
	
	var jump_pressed:bool = (current_time-jump_last_pressed_time) < jump_buffer_time_msec
	
	if jump_pressed and jump_aviable and !is_jumping: #and count jumps 
		jump_aviable_count  -= 1
		is_jumping = true
		is_hovering = false
		jump_start_time = current_time
		jump_time = speed_dict[shape_name_current][location][JUMPING_TIME][0]
		jump_last_pressed_time = 0
	
	var jump_is_over:bool = (current_time - jump_start_time) > jump_time
	if jump_is_over and is_jumping:
		is_jumping = false
		is_hovering = true
		hover_time = speed_dict[shape_name_current][location][JUMPING_TIME][1]
		hover_start_time = current_time
	
	if is_jumping:
		velocity.y = move_toward(
			velocity.y,
			speed_dict[shape_name_current][location][JUMPING][MAX_SPEED] * gravity_state * -1, 
			speed_dict[shape_name_current][location][JUMPING][ACCELERATION] * delta)
	
	var hover_is_over:bool = (current_time - hover_start_time) > hover_time
	if hover_is_over and is_hovering:
		is_hovering = false
	
	if is_hovering:
		velocity.y = move_toward(
			velocity.y,
			speed_dict[shape_name_current][location][HOVERING][MAX_SPEED] * gravity_state, 
			speed_dict[shape_name_current][location][HOVERING][ACCELERATION] * delta)
	
	var fall_fast_over:bool = (current_time - fall_fast_start) > fall_fast_time
	if fall_fast_over and is_fall_fast:
		fall_fast_down(false)
	
	if is_fall_fast:
		velocity.y = move_toward(
			velocity.y,
			fall_fast_speed[MAX_SPEED] * gravity_state, 
			fall_fast_speed[ACCELERATION] * delta)
	
func check_input_and_change_velocity(delta):
	update_location()
	falling(delta)
	moving(delta)
	jumping_and_hovering(delta)

var ability_aviable = true
func ability_after_jump():
	if ability_aviable:
		var shape_name = $ShapeManager.get_curr_shape_name()
		
		match shape_name:
			ShapeData.shape_names.TRIANGLE_DOWN:
				fall_fast_down()
				ability_aviable = false
				return true
			ShapeData.shape_names.TRIANGLE_UP:
				change_gravity()
				return true
	return false

func change_gravity(grav_val = 0):
	if grav_val == 0:
		gravity_state *= -1
	else:
		gravity_state = grav_val
	up_direction = Vector2(0, gravity_state * -1)

var shape_name_current
#FIXME: добавить определение при инициализации
func make_switch_shape():
	switch_shape.emit()
	check_new_shape()
	
func check_new_shape():
	shape_name_current =  $ShapeManager.get_curr_shape_name()
	if shape_name_current == ShapeData.shape_names.CIRCLE:
		jump_max_count = 2
	else:
		jump_max_count = 1
	
	if gravity_state != 1:
		change_gravity(1)
		
	if shape_name_current == ShapeData.shape_names.SQUARE_BIG:
		set_collision_layer_value(4, true)
	else:
		set_collision_layer_value(4, false)
	

var is_fall_fast = false
var fall_fast_time = 700
var fall_fast_start = 0
var fall_fast_speed = [400, 200*60, 200*60]
func fall_fast_down(is_enable = true): #TODO: добавить обнаружение ломаемых и пропускаемых блоков блоков 
	if is_enable:
		fall_fast_start = current_time
	
	is_fall_fast = is_enable
	if $AreaDestroy/CollisionShape2D.disabled != !is_enable:
		$AreaDestroy/CollisionShape2D.set_deferred("disabled", !is_enable)
	
	

func _physics_process(delta):
	current_time = Time.get_ticks_msec()
	check_input_and_change_velocity(delta)
	if Input.is_action_just_pressed("action_switch_shape"):
		make_switch_shape()
	if Input.is_action_just_pressed("action_switch_color"):
		switch_color.emit()
	if Input.is_action_just_pressed("menu_pick_shape"):
		open_menu.emit(GameManager.menu_names.pick)
	move_and_slide()


func _on_shape_manager_shape_updated():
	check_new_shape()
