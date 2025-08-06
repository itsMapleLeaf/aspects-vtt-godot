extends Control

@onready var viewport: RoomViewport = %Viewport


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_RIGHT:
			viewport.offset += event.relative
			get_viewport().set_input_as_handled()

	elif event is InputEventMouseButton:
		if event.is_pressed():
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					viewport.update_zoom(1, event.position)
					get_viewport().set_input_as_handled()
				MOUSE_BUTTON_WHEEL_DOWN:
					viewport.update_zoom(-1, event.position)
					get_viewport().set_input_as_handled()

	elif event is InputEventPanGesture:
		position += event.delta
		get_viewport().set_input_as_handled()

	elif event is InputEventMagnifyGesture:
		viewport.update_zoom(event.factor, event.position)
		get_viewport().set_input_as_handled()

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is AssetCard.DragData

func _drop_data(at_position: Vector2, data_arg: Variant) -> void:
	var data: AssetCard.DragData = data_arg

	var sprite := Sprite2D.new()
	sprite.texture = ImageTexture.create_from_image(data.asset.get_image())
	viewport.add_child(sprite)
	sprite.position = (at_position - viewport.offset) / viewport.scale
