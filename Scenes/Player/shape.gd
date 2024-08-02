class_name Shape extends Node2D

@export var sprite: AnimatedSprite2D
@export var collision: CollisionShape2D

@export var shape_name : ShapeData.shape_names
var is_enabled = false

func _ready():
	collision.disabled = true
	disable_shape()

func enable_shape(color_id):
	print_debug("enable_shape")
	sprite.visible = true
	is_enabled = true
	change_color(color_id)
	collision.show()
	
	
func disable_shape():
	sprite.visible = false
	is_enabled = false
	collision.hide() 

func change_color(color_num):
	$AnimatedSprite2D.play(str(color_num))
