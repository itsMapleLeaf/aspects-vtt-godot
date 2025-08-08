class_name DragSelection
extends Panel

var is_drag_selecting := false
var drag_select_start := Vector2()
var drag_select_end := Vector2()
@onready var drag_selection: Control = %DragSelection

var drag_select_rect: Rect2:
	get:
		return Rect2(
			drag_select_start,
			drag_select_end - drag_select_start,
		).abs()

func _process(delta: float) -> void:
	if is_drag_selecting:
		drag_selection.visible = true
		drag_selection.position = drag_select_rect.position
		drag_selection.size = drag_select_rect.size
	else:
		drag_selection.visible = false

func start_selecting(at_global_position: Vector2) -> void:
	is_drag_selecting = true
	drag_select_start = at_global_position
	drag_select_end = at_global_position

func continue_selecting(at_global_position: Vector2) -> bool:
	if is_drag_selecting:
		drag_select_end = at_global_position
		return true

	return false

func stop_selecting(at_global_position: Vector2) -> void:
	is_drag_selecting = false
