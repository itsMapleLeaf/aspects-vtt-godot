extends Node2D
class_name Actor

@onready var sprite: TextureRect = %Image
@onready var selection_highlight: ColorRect = %SelectionHighlight
@onready var control: Control = %Control

signal selected

var is_selected := false:
	set(new_is_selected):
		is_selected = new_is_selected
		selection_highlight.modulate.a = 1 if new_is_selected else 0

var image: Image:
	get:
		return sprite.texture.get_image()
	set(new_image):
		sprite.texture = ImageTexture.create_from_image(new_image)


var selection_hitbox: Rect2:
	get:
		return control.get_global_rect()

func _ready() -> void:
	control.mouse_filter = Control.MOUSE_FILTER_PASS


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			selected.emit()
