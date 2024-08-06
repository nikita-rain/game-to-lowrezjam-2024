extends Area2D

signal update_signal(update_active)
@export var is_oneshot = true
@export var signal_val = false


func _on_body_entered(body):
	update_signal.emit(signal_val)
	if is_oneshot:
		$CollisionShape2D.set_deferred("disabled", true) 
