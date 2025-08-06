@tool
extends Control
class_name RatioControl

var last_width := size.x

@export_range(0.1, 10.0, 0.1) var ratio := 1.0:
	set(new_ratio):
		ratio = new_ratio
		_on_resized()

func _enter_tree() -> void:
	if not resized.is_connected(_on_resized):
		resized.connect(_on_resized)

func _on_resized() -> void:
	if last_width != size.x:
		custom_minimum_size.y = size.x * ratio
		last_width = size.x
