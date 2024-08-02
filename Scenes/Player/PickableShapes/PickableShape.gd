extends Area2D

@export var shape_data: ShapeData
@export var shape_name: ShapeData.shape_names


func _on_body_entered(body):
	shape_data.shape_is_aviable[shape_name] = true
	queue_free()
