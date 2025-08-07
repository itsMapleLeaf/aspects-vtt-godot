extends Node2D
class_name Stage

const ActorScene = preload("res://actor.tscn")

var camera := StageCamera.new()


func add_actor(image: Image, position: Vector2) -> void:
	var actor: Actor = ActorScene.instantiate()
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
			.scaled(camera.zoom_coefficient ** camera.zoom_tick * Vector2.ONE)
			.translated(camera.offset),
		delta * camera.stiffness,
	)
