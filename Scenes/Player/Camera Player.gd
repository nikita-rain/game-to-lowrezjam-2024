extends Camera2D

@onready var camera_wight = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var camera_height = ProjectSettings.get_setting("display/window/size/viewport_height")

 #TODO: добавить функцию перемещения более чем на один экран

func _on_area_2d_body_exited(body):
	var len_x = self.global_position.x - body.global_position.x
	if len_x > 0 and len_x > ($Area2D/CollisionShape2D.shape.size.x / 2.0):
		self.global_position.x -= camera_wight
	elif len_x < 0 and abs(len_x) > ($Area2D/CollisionShape2D.shape.size.x / 2.0):
		self.global_position.x += camera_wight
	
	var len_y = self.global_position.y - body.global_position.y
	if len_y > 0 and len_y > ($Area2D/CollisionShape2D.shape.size.y / 2.0):
		self.global_position.y -= camera_height
	elif len_y < 0 and abs(len_y) > ($Area2D/CollisionShape2D.shape.size.y / 2.0):
		self.global_position.y += camera_height
	
