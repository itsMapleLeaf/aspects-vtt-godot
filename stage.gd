extends Node2D
class_name Stage

const ActorScene = preload("res://actor.tscn")

var camera := StageCamera.new()

func _process(delta: float) -> void:
	transform = transform.interpolate_with(
		Transform2D()
			.scaled(camera.zoom_coefficient ** camera.zoom_tick * Vector2.ONE)
			.translated(camera.offset),
		delta * camera.stiffness,
	)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					select_actors([])
					get_viewport().set_input_as_handled()
				MOUSE_BUTTON_WHEEL_UP:
					camera.update_zoom(1, event.position)
					get_viewport().set_input_as_handled()
				MOUSE_BUTTON_WHEEL_DOWN:
					camera.update_zoom(-1, event.position)
					get_viewport().set_input_as_handled()

	elif event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
			camera.offset += event.relative
			get_viewport().set_input_as_handled()

	elif event is InputEventPanGesture:
		position += event.delta
		get_viewport().set_input_as_handled()

	elif event is InputEventMagnifyGesture:
		camera.update_zoom(event.factor, event.position)
		get_viewport().set_input_as_handled()


func _on_actor_pressed(actor: Actor) -> void:
	select_actors([actor])


func add_actor(image: Image, position: Vector2) -> void:
	var actor: Actor = ActorScene.instantiate()
	add_child(actor)
	actor.position = position
	actor.image = image
	actor.selected.connect(_on_actor_pressed.bind(actor))


func select_actors(actors: Array[Actor]) -> void:
	for actor in get_children():
		if actor is Actor:
			actor.is_selected = actors.has(actor)
