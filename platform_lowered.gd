class_name PlatformLowered extends Node2D

@export var connected_active_nodes: Array[Node]
signal update_signal(update_active)


@export var is_move_back = true
@export var is_move_back_after_end_point = true
@export var platform_can_press = false
@export var platform_speed = 30.0
var is_pressing = false
var is_pressed = false

@export_category("Connected Platform")
@export var connected_platform: PlatformLowered
@export var is_reversed:bool = false
var is_platform_connected:bool = false

var start_point
var end_point

func _ready():
	make_points()
	if connected_platform:
		is_platform_connected = true
	
	if !is_move_back and is_move_back_after_end_point:
		push_error("флаги движения конфликтуют, движение после нажатия принудительно отменено")
		is_move_back_after_end_point = false
		
	for node in get_children():
		if node is Line2D:
			node.add_point($start_point.position)
			node.add_point($end_point.position)
		
	for node in connected_active_nodes:
		if node.has_method("_on_update_signal"):
			update_signal.connect(node._on_update_signal)


func _physics_process(delta):
	if is_pressing and !is_pressed:
		$StaticBody2D.position = $StaticBody2D.position.move_toward(end_point, platform_speed * delta)
		if end_point == $StaticBody2D.position and platform_can_press:
			is_pressed = true
			update_signal.emit(true)
	elif !is_pressing and is_pressed and is_move_back_after_end_point:
		update_signal.emit(false)
		is_pressed = false
	
	if !is_pressing and $StaticBody2D.position != start_point and !is_pressed and is_move_back:
		$StaticBody2D.position = $StaticBody2D.position.move_toward(start_point, platform_speed * delta)
	

func enable_moving():
	is_pressing = true

func make_points(reverse_move = false):
	if !reverse_move:
		start_point = $start_point.position
		end_point = $end_point.position
	else:
		start_point =  $end_point.position
		end_point = $start_point.position

func disable_moving():
	is_pressing = false
	make_points()

func _on_area_2d_body_entered(_body):
	enable_moving()
	if is_platform_connected:
		connected_platform.make_points(is_reversed)
		connected_platform.enable_moving()

func _on_area_2d_body_exited(_body):
	if !$StaticBody2D/Area2D.has_overlapping_bodies():
		disable_moving()
		if is_platform_connected:
			connected_platform.disable_moving()
