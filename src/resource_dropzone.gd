extends Control

@onready var viewport: Node2D = %Viewport

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is AssetCard.DragData

func _drop_data(at_position: Vector2, data_arg: Variant) -> void:
	var data: AssetCard.DragData = data_arg

	var sprite := Sprite2D.new()
	sprite.texture = ImageTexture.create_from_image(data.asset.get_image())
	sprite.position = at_position
	viewport.add_child(sprite)
