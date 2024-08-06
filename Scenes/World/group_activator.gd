extends Node2D

signal update_signal(update_active)

# Called when the node enters the scene tree for the first time.
var objects = []
func _ready():
	var children = get_children()
	for node in get_tree().get_nodes_in_group("active_item"):
		if node in children and node.has_method("_on_update_signal"):
			update_signal.connect(node._on_update_signal)
		


func _on_button_update_signal(update_active):
	update_signal.emit(update_active)
