@tool
extends Control
class_name RatioControl

var last_size := size

@export_range(0.1, 10.0, 0.1) var ratio := 1.0:
	set(new_ratio):
		ratio = new_ratio
		_on_resized()

func _enter_tree() -> void:
	if not resized.is_connected(_on_resized):
		resized.connect(_on_resized)

func _on_resized() -> void:
	if last_size.is_equal_approx(size): return

	var height := size.x * ratio
	size.y = height
	custom_minimum_size.y = height

	last_size = size
