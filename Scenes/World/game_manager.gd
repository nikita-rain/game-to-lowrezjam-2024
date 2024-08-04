class_name GameManager extends Node

#TODO: посмотреть как можно сделать худ отдельным нодом от камеры 
enum menu_names {main, pick}

var active_menu: Array[menu_names]
@export var menu_pick: MenuPick
 #TODO: изменить на загрузку, узнать как сделать элемент поверх камеры, или загружать с камерой  

func _ready():
	pass # Replace with function body.



func _process(delta):
	pass


func _on_player_open_menu(menu):
	match menu:
		menu_names.pick:
			menu_pick.enable_menu()
			active_menu.append(menu)
			check_active_menu()
	
	pass # Replace with function body.

func _on_menu_pick_shape_close_menu(menu_name):
	active_menu.erase(menu_name)
	if active_menu.size() == 0:
		game_paused = false
		get_tree().paused = false

var game_paused = false
func check_active_menu():
	if active_menu.size() > 0 and !game_paused:
		print_debug("pause")
		game_paused = true
		get_tree().paused = true



