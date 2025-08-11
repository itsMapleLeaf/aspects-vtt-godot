extends Node2D
class_name Stage

var camera := StageCamera.new()

@onready var drag_selection: DragSelection = %DragSelection

var is_dragging_actors := false
var actor_drag_offset := Vector2.ZERO


func add_actor(image: Image, at_position: Vector2) -> void:
	var actor: Actor = preload("res://src/actor.tscn").instantiate()
	add_child(actor)
	actor.position = at_position
	actor.image = image
	actor.selected.connect(_on_actor_pressed.bind(actor))


func _on_actor_pressed(actor: Actor) -> void:
	if not actor.is_selected:
		select_actors([actor])


func get_actors() -> Array[Actor]:
	var result: Array[Actor] = []
	for node in get_children():
		if node is Actor:
			result.append(node)
	return result


func select_actors(actors: Array[Actor]) -> void:
	for actor in get_actors():
		actor.is_selected = actors.has(actor)


func _process(delta: float) -> void:
	transform = transform.interpolate_with(
		Transform2D()
			.scaled(camera.zoom_coefficient ** camera.zoom_tick * Vector2.ONE)
			.translated(camera.offset),
		delta * camera.stiffness,
	)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				var clicked_actor := false
				var started_drag := false

				for actor in get_actors():
					if actor.selection_hitbox.has_point(event.global_position):
						clicked_actor = true
						if actor.is_selected:
							is_dragging_actors = true
							actor_drag_offset = to_local(event.global_position)
							started_drag = true
							break

				if not started_drag and not clicked_actor:
					select_actors([])
					drag_selection.start_selecting(event.global_position)

				get_viewport().set_input_as_handled()

			if event.is_released():
				if is_dragging_actors:
					is_dragging_actors = false
					get_viewport().set_input_as_handled()

				drag_selection.stop_selecting(event.global_position)
				get_viewport().set_input_as_handled()

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			camera.update_zoom(1, event.position)
			get_viewport().set_input_as_handled()

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			camera.update_zoom(-1, event.position)
			get_viewport().set_input_as_handled()

	elif event is InputEventMouseMotion:
		if (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
			if is_dragging_actors:
				var now_local := to_local(event.global_position)
				var delta_local := now_local - actor_drag_offset
				if delta_local != Vector2.ZERO:
					for actor in get_actors():
						if actor.is_selected:
							actor.position += delta_local
					actor_drag_offset = now_local
				get_viewport().set_input_as_handled()
			else:
				if drag_selection.continue_selecting(event.global_position):
					var selected_actors: Array[Actor] = []
					for actor in get_actors():
						if actor.selection_hitbox.intersects(drag_selection.drag_select_rect):
							selected_actors.append(actor)

					select_actors(selected_actors)
					get_viewport().set_input_as_handled()

		elif (event.button_mask & MOUSE_BUTTON_MASK_RIGHT) != 0:
			camera.offset += event.relative
			get_viewport().set_input_as_handled()

	elif event is InputEventPanGesture:
		position += event.delta
		get_viewport().set_input_as_handled()

	elif event is InputEventMagnifyGesture:
		camera.update_zoom(event.factor, event.position)
		get_viewport().set_input_as_handled()
