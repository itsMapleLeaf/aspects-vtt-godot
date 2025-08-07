extends Node2D
class_name Actor

@onready var sprite: TextureRect = %Image
@onready var selection_highlight: ColorRect = %SelectionHighlight

signal pressed

var selected := false:
	set(new_selected):
		selected = new_selected
		selection_highlight.modulate.a = 1 if new_selected else 0

var image: Image:
	get:
		return sprite.texture.get_image()
	set(new_image):
		sprite.texture = ImageTexture.create_from_image(new_image)


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			pressed.emit()
			get_viewport().set_input_as_handled()
