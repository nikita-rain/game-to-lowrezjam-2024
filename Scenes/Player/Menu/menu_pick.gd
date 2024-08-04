class_name MenuPick extends Node2D

#TODO: фактически менять форму только при выключении 

signal close_menu(menu_name: GameManager.menu_names)
signal change_item(item_id:int, item_type:ShapeData.type_item)

var shape_row = 0
var shape_item = 1

var color_row = 1
var color_item = 0

@export var row_list: Array[MenuRow]
@export var is_switch_to_next_row = true
var row_len: Array[int]
var cursor_row:int = 0
var cursor_item:int = 1

var menu_name: GameManager.menu_names = GameManager.menu_names.pick

func _ready():
	for row in row_list:
		row_len.append(row.get_item_count())
	hide()
	set_process(false) 
	update_picked_cell_sprite()
	update_cursor()

func update_picked_items():
	#TODO: получать от менеджера форм 
	if row_list[shape_row].type_of_object != ShapeData.type_item.SHAPES:
		push_error("указатель на неверном типе")
	else:
		change_item.emit(shape_item, ShapeData.type_item.SHAPES)
	
	if row_list[color_row].type_of_object != ShapeData.type_item.COLORS:
		push_error("указатель на неверном типе")
	else:
		change_item.emit(color_item, ShapeData.type_item.COLORS)
	
		#это на перемещение указателей
		#$PickedShape.global_position = row_list[shape_row].get_global_pos_node(shape_item)

func _process(delta):
	#TODO: сделать возможноть зажимать кнопку 
	var move_in_row = 0
	var move_in_table = 0
	if Input.is_action_just_pressed("menu_pick_shape") and !ignore_frame:
		disable_menu()
		return
	if ignore_frame:
		ignore_frame = false
	if Input.is_action_just_pressed("move_right"):
		move_in_row += 1
	if Input.is_action_just_pressed("move_left"):
		move_in_row -= 1
	if Input.is_action_just_pressed("move_up"):
		move_in_table += 1
	if Input.is_action_just_pressed("move_down"):
		move_in_table -= 1
	if move_in_row or move_in_table:
		update_cursor(move_in_row, move_in_table)
	if Input.is_action_just_pressed("move_jump"):
		cursor_pick_item()
	pass

func change_picked_item():
	pass

func cursor_pick_item():
	#TODO: добавить проверку валидности формы
	if !cursor_is_valid():
		return
	match row_list[cursor_row].type_of_object: 
		ShapeData.type_item.SHAPES:
			shape_row = cursor_row
			shape_item = cursor_item
		ShapeData.type_item.COLORS:
			color_row = cursor_row
			color_item = cursor_item
	update_picked_cell_sprite()

func update_picked_cell_sprite():
	$PickedShape.global_position = row_list[shape_row].get_global_pos_node(shape_item)
	$PickedColor.global_position = row_list[color_row].get_global_pos_node(color_item)

func cursor_is_valid():
	return row_list[cursor_row].is_valid_cell(cursor_item)

#FIXME: сделать скип пустых значений
func update_cursor(move_in_row:int = 0, move_in_table:int = 0):
	print_debug("cursor upd")
	#TODO: обработать логику с переводом и одновременным смещением строки
	if is_switch_to_next_row and move_in_table == 0: #Перевод строки 
		var row_feed = 0
		if move_in_row + cursor_item >= row_len[cursor_row]:
			row_feed = 1
		if move_in_row + cursor_item < 0:
			row_feed = -1
		cursor_row = wrapi(cursor_row + row_feed, 0, row_len.size())
	cursor_row = wrapi(cursor_row + move_in_table, 0, row_len.size())
	cursor_item = wrapi(cursor_item + move_in_row, 0, row_len[cursor_row])
	
	$Cursor.global_position = row_list[cursor_row].get_global_pos_node(cursor_item)

var ignore_frame = false #не знаю как иначе сделать
func enable_menu():
	#TODO: add upd
	print_debug("enable menu")
	for row in row_list:
		row.update_item()
	show()
	ignore_frame = true
	set_process(true)

func disable_menu():
	print_debug("disable menu")
	hide()
	close_menu.emit(menu_name)
	update_picked_items()
	set_process(false)
