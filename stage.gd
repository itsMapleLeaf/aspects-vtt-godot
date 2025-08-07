extends Node2D
class_name Stage

const Actor = preload("res://actor.tscn")

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


func add_actor(image: Image, position: Vector2) -> void:
	var actor: Actor = Actor.instantiate()
	add_child(actor)
	actor.position = position
	actor.image = image
	actor.pressed.connect(_on_actor_pressed.bind(actor))


func _on_actor_pressed(actor: Actor) -> void:
	select_actors([actor])


func select_actors(actors: Array[Actor]) -> void:
	for actor in get_children():
		if actor is Actor:
			actor.is_selected = actors.has(actor)


func _process(delta: float) -> void:
	transform = transform.interpolate_with(
		Transform2D()
			.scaled(zoom_coefficient ** zoom_tick * Vector2.ONE)
			.translated(offset),
		delta * stiffness,
	)
