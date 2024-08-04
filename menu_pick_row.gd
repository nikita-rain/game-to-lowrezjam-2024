class_name MenuRow extends Node2D

var item_list: Array
var item_vals: Array

@export var type_of_object: ShapeData.type_item
@export var shapes_data: ShapeData
var region_rect_y = 0

var cell_w = 8.0
var cell_h = 8.0

var cell_wrong_x = 8 * 8
var cell_wrong_y = 48

func _ready():
	item_list = get_children()
	item_vals = get_item_vals()
	match type_of_object:
		ShapeData.type_item.SHAPES:
			region_rect_y = 48
		ShapeData.type_item.COLORS:
			region_rect_y = 48 + 8
	
	if item_vals.size() != item_list.size():
		push_error("Размер меню и существующих форм не соответствует")
	for i in range(0, item_list.size()):
		item_list[i].region_enabled = true
		if item_vals[i] == true:
			item_list[i].region_rect = Rect2(i * 8, region_rect_y, cell_w, cell_h)
		else:
			item_list[i].region_rect = Rect2(cell_wrong_x, cell_wrong_y, cell_w, cell_h)


func get_item_vals():
	match type_of_object:
		ShapeData.type_item.SHAPES:
			return shapes_data.shape_is_aviable.values()
		ShapeData.type_item.COLORS:
			return shapes_data.color_is_aviable

func get_global_pos_node(id: int) -> Vector2:
	if id >= item_list.size() or id < 0:
		push_error("Обращение на несуществующий индекс")
		return Vector2.ZERO
	return item_list[id].global_position #FIXME: поменять на position 

func get_item_count():
	return item_list.size()

