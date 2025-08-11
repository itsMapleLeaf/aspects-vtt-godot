extends TextureButton
class_name AssetCard

@onready var drag_preview: TextureRect = %DragPreview

func _get_drag_data(at_position: Vector2) -> Variant:
	var preview := Control.new()

	var preview_image: TextureRect = drag_preview.duplicate()
	preview.add_child(preview_image)
	preview_image.visible = true
	preview_image.position = -preview_image.size / 2

	set_drag_preview(preview)

	return DragData.new(preload("res://assets/riley.png"))

class DragData:
	var asset: CompressedTexture2D

	func _init(asset: CompressedTexture2D) -> void:
		self.asset = asset
