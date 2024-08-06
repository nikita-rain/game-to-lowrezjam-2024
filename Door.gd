extends StaticBody2D


@export var is_closed = true

func _ready():
	if is_closed:
		close_door()
	else:
		open_door()

func open_door():
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("open")

func close_door():
	$CollisionShape2D.set_deferred("disabled", false) 
	$AnimatedSprite2D.play("close")


func _on_update_signal(update_active):
	if update_active:
		open_door()
	else:
		close_door()



