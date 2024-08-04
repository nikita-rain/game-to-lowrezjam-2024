class_name MenuPick extends Node2D

signal close_menu(menu_name: GameManager.menu_names)

@export var row_list: Array[MenuRow]
@export var is_switch_to_next_row = true
var row_len: Array[int]
var cursor_row:int = 0
var cursor_item:int = 0

var menu_name: GameManager.menu_names = GameManager.menu_names.pick

func _ready():
	for row in row_list:
		row_len.append(row.get_item_count())
	hide()
	set_process(false) 

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
		pass
	pass



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
	print_debug("enable menu")
	show()
	ignore_frame = true
	set_process(true)

func disable_menu():
	print_debug("disable menu")
	hide()
	close_menu.emit(menu_name)
	set_process(false)
