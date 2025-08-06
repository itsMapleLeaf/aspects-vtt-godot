extends Node2D
class_name RoomViewport

@export var offset := Vector2()
@export_range(1.0, 2.0, 0.01) var zoom_coefficient := 1.3
@export_range(10, 50, 1) var stiffness := 30.0
@export_range(-10, 10, 1) var zoom_tick := 0.0

var zoom_scale: float:
	get: return _get_zoom_scale(zoom_tick)


func _get_zoom_scale(tick: float) -> float:
	return zoom_coefficient ** tick


func update_zoom(delta: float, pivot: Vector2) -> void:
	var new_zoom_tick := zoom_tick + delta

	var current_scale := _get_zoom_scale(zoom_tick)
	var new_scale := _get_zoom_scale(new_zoom_tick)

	var local_pivot := pivot - offset
	var shift := local_pivot - local_pivot * (new_scale / current_scale)

	zoom_tick = new_zoom_tick
	offset += shift


func _process(delta: float) -> void:
	transform = transform.interpolate_with(
		Transform2D()
			.scaled(zoom_coefficient ** zoom_tick * Vector2.ONE)
			.translated(offset),
		delta * stiffness,
	)
