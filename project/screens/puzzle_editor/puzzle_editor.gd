class_name PuzzleEditor
extends Node2D

@export var play_menu: PackedScene
@onready var grid:Grid = $Grid
@onready var interface_layer: CanvasLayer = %InterfaceLayer
@onready var camera:GameCamera = $Camera2D

var planet_name: String = "PlanetX"
var grid_width: int = 1
var grid_height: int = 1
var difficulty: int = 1
var time_until_humans: int = 100
var last_hovered_tile: Tile

func _on_test_button_pressed() -> void:
	pass # Replace with function body.

func _on_save_button_pressed() -> void:
	var resource = grid.export_to_resource()
	resource.name = planet_name
	var path : String = "res://%s.tres" % planet_name
	var error := ResourceSaver.save(resource, path)
	if error:
		print("An error happened while saving data: ", error)

func _ready() -> void:
	grid.build_grid(grid_width, grid_height)
	camera.zoom_to_fit(grid.get_grid_tile_width(), grid.get_grid_tile_height())
	grid.connect("on_mouse_entered_tile", _on_mouse_entered_tile)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_open_play_menu"):
		interface_layer.add_child(play_menu.instantiate())
		get_viewport().set_input_as_handled()
		
func _on_mouse_entered_tile(tile: Tile):
	if last_hovered_tile != null:
		last_hovered_tile.highlight_tile(false)
	last_hovered_tile = tile
	tile.highlight_tile(true)

func _on_planet_name_text_submitted(new_text: String) -> void:
	planet_name = new_text

func _on_grid_width_value_changed(new_value: int) -> void:
	grid_width = new_value
	grid.build_grid(grid_width, grid_height)
	camera.zoom_to_fit(grid.get_grid_tile_width(), grid.get_grid_tile_height())

func _on_grid_height_value_changed(new_value: int) -> void:
	grid_height = new_value
	grid.build_grid(grid_width, grid_height)
	camera.zoom_to_fit(grid.get_grid_tile_width(), grid.get_grid_tile_height())

func _on_difficulty_value_changed(new_value: int) -> void:
	difficulty = new_value

func _on_time_until_humans_value_changed(new_value: int) -> void:
	time_until_humans = new_value
