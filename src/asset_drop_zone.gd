extends Control

@onready var stage: Stage = %Stage

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is AssetCard.DragData

func _drop_data(at_position: Vector2, data_arg: Variant) -> void:
	var data: AssetCard.DragData = data_arg

	stage.add_actor(
		data.asset.get_image(),
		(at_position - stage.camera.offset + position)
		/ stage.camera.zoom_scale,
	)
