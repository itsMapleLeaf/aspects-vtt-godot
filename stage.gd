extends Node2D
class_name Stage

var camera := StageCamera.new()

@onready var drag_selection: DragSelection = %DragSelection

func _process(delta: float) -> void:
	transform = transform.interpolate_with(
		Transform2D()
			.scaled(camera.zoom_coefficient ** camera.zoom_tick * Vector2.ONE)
			.translated(camera.offset),
		delta * camera.stiffness,
	)

func _unhandled_input(event: InputEvent) -> void:
	var handled := (
		_handle_mouse_drag_select(event)
		or _handle_mouse_pan(event)
		or _handle_wheel_zoom(event)
		or _handle_touch_pan(event)
		or _handle_touch_zoom(event)
	)

	if handled:
		get_viewport().set_input_as_handled()

func _handle_mouse_drag_select(event: InputEvent) -> bool:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			select_actors([])
			drag_selection.start_selecting(event.global_position)
			return true

		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			drag_selection.stop_selecting(event.global_position)
			return true

	if (
		event is InputEventMouseMotion
		and event.button_mask & MOUSE_BUTTON_MASK_LEFT
		and drag_selection.continue_selecting(event.global_position)
	):
		var selected_actors: Array[Actor] = []
		for node in get_children():
			if node is Actor and node.selection_hitbox.intersects(drag_selection.drag_select_rect):
				selected_actors.append(node)

		select_actors(selected_actors)

		return true

	return false

func _handle_mouse_pan(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
			camera.offset += event.relative
		return true

	return false

func _handle_touch_pan(event: InputEvent) -> bool:
	if event is InputEventPanGesture:
		position += event.delta
		return true

	return false

func _handle_wheel_zoom(event: InputEvent) -> bool:
	if event is InputEventMouseButton: if event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.update_zoom(1, event.position)
			return true

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.update_zoom(-1, event.position)
			return true

	return false

func _handle_touch_zoom(event: InputEvent) -> bool:
	if event is InputEventMagnifyGesture:
		camera.update_zoom(event.factor, event.position)
		return true

	return false


func _on_actor_pressed(actor: Actor) -> void:
	select_actors([actor])


func add_actor(image: Image, at_position: Vector2) -> void:
	var actor: Actor = preload("res://actor.tscn").instantiate()
	add_child(actor)
	actor.position = at_position
	actor.image = image
	actor.selected.connect(_on_actor_pressed.bind(actor))


func select_actors(actors: Array[Actor]) -> void:
	for actor in get_children():
		if actor is Actor:
			actor.is_selected = actors.has(actor)
