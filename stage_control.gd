extends Control

@onready var stage: Stage = %Stage


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					stage.deselect_actors()
					get_viewport().set_input_as_handled()
				MOUSE_BUTTON_WHEEL_UP:
					stage.update_zoom(1, event.position)
					get_viewport().set_input_as_handled()
				MOUSE_BUTTON_WHEEL_DOWN:
					stage.update_zoom(-1, event.position)
					get_viewport().set_input_as_handled()

	elif event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
			stage.offset += event.relative
			get_viewport().set_input_as_handled()

	elif event is InputEventPanGesture:
		position += event.delta
		get_viewport().set_input_as_handled()

	elif event is InputEventMagnifyGesture:
		stage.update_zoom(event.factor, event.position)
		get_viewport().set_input_as_handled()

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is AssetCard.DragData

func _drop_data(at_position: Vector2, data_arg: Variant) -> void:
	var data: AssetCard.DragData = data_arg

	stage.add_actor(
		data.asset.get_image(),
		(at_position - stage.offset) / stage.scale,
	)
