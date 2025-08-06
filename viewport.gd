extends Node2D


@export var offset := Vector2()
@export_range(-10, 10, 1) var zoom_tick := 0.0
@export_range(1.0, 2.0, 0.01) var zoom_coefficient := 1.3
@export_range(10, 50, 1) var stiffness := 30.0


func _get_zoom_scale(tick: float) -> float:
	return zoom_coefficient ** tick


func _update_zoom(delta: float, pivot: Vector2) -> void:
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


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
			offset += event.relative
			get_viewport().set_input_as_handled()

	elif event is InputEventMouseButton:
		if event.is_pressed():
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					_update_zoom(1, event.position)
					get_viewport().set_input_as_handled()
				MOUSE_BUTTON_WHEEL_DOWN:
					_update_zoom(-1, event.position)
					get_viewport().set_input_as_handled()

	elif event is InputEventPanGesture:
		position += event.delta
		get_viewport().set_input_as_handled()

	elif event is InputEventMagnifyGesture:
		_update_zoom(event.factor, event.position)
		get_viewport().set_input_as_handled()
