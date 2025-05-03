class_name GameCamera
extends Camera2D

@export var buffer: float
@export var base_zoom: float

var grid_width
var grid_height
var window_size

func zoom_to_fit(width: int, height: int):
	grid_width = width
	grid_height = height
	var full_width = width + buffer
	var full_height = height + buffer
	window_size = get_viewport().get_visible_rect().size
	var cur_zoom = zoom.x
	
	var zoom_modifier_x = window_size.x/full_width
	var zoom_modifier_y = window_size.y/full_height
	var zoom_to_apply
	if zoom_modifier_x < zoom_modifier_y:
		zoom_to_apply = base_zoom * zoom_modifier_x
	else:
		zoom_to_apply = base_zoom * zoom_modifier_y

	zoom.x = zoom_to_apply
	zoom.y = zoom.x

	return

func _process(delta: float) -> void:
	if get_viewport().get_visible_rect().size != window_size:
		zoom_to_fit(grid_width, grid_height)
	return
