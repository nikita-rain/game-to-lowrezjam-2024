extends Node2D

#FIXME: переделать фигурсы с полигонов на спрайты
@export var player_collision_shape : CollisionShape2D
var shapes: Array[Node]


@export var shape_data: ShapeData


# Called when the node enters the scene tree for the first time.
func _ready():
	var shapes_name_shape_is_aviable: Array
	shapes = get_children()
	for shape:Shape in shapes:
		if shape.shape_name in shapes_name_shape_is_aviable:
			push_error("повторяющиеся фигуры в менеджере")
		else:
			shapes_name_shape_is_aviable.append(shape.shape_name)
	enable_shape_by_name(shape_data.shape_names.SQUARE, color_id)
	
func enable_shape_by_name(shape_name_to_enable, color_to_switch = color_id):
	color_id = color_to_switch
	if shape_data.shape_is_aviable[shape_name_to_enable] == false:
		push_error("попытка включить недоступную форму")
		switch_shape()
		return
	
	for x in range(0, shapes.size()):
		if shapes[x].shape_name == shape_name_to_enable:
			shape_id = x
			shapes_change_state()

var shape_id = 0
var color_id = 0
func switch_shape():
	print_debug("switch")
	var moves = 0
	shape_id = wrapi(shape_id+1,0, shapes.size())
	while shape_data.shape_is_aviable[shapes[shape_id].shape_name] != true:
		shape_id = wrapi(shape_id+1,0, shapes.size())
		moves += 1
		if moves > shapes.size():
			push_error("Нет доступных форм")
			break
	shapes_change_state()


func shapes_change_state():
	if shape_data.shape_is_aviable[shapes[shape_id].shape_name]:
		var prev_shape_id = find_enabled_shape_index()
		print_debug("change_shape from " + str(prev_shape_id) + " to " + str(shape_id) )
		if prev_shape_id != -1 and prev_shape_id != shape_id:
			shapes[prev_shape_id].disable_shape()
		if prev_shape_id != shape_id:
			shapes[shape_id].enable_shape(color_id)
			if player_collision_shape.shape != shapes[shape_id].collision.shape:
				player_collision_shape.shape = shapes[shape_id].collision.shape
	else:
		push_error("Указана недоступная фигура")

func find_enabled_shape_index():
	for x in range(0, shapes.size()):
		if shapes[x].is_enabled:
			return x
	return -1

@onready var color_count = shape_data.color_is_aviable.size()

func switch_color():
	color_id = wrapi(color_id+1, 0, color_count)
	var moves = 0
	while shape_data.color_is_aviable[color_id] != true:
		color_id = wrapi(color_id+1, 0, color_count)
		moves += 1
		if moves > color_count:
			push_error("Нет доступных цветов")
			break
	shapes[shape_id].change_color(color_id)

func get_curr_shape_name():
	return shapes[shape_id].shape_name

func _on_player_switch_shape():
	switch_shape()

func _on_player_switch_color():
	switch_color()
