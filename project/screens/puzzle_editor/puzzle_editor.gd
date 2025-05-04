class_name PuzzleEditor
extends Node2D

@export var play_menu: PackedScene
@onready var grid:Grid = $Grid
@onready var interface_layer: CanvasLayer = %InterfaceLayer
@onready var camera:GameCamera = $Camera2D
@onready var tile_options_container:VBoxContainer = $InterfaceLayer/TileOptionsContainer
@onready var tile_options_grid:GridContainer = $InterfaceLayer/TileOptionsContainer/TileGrid
@onready var player_sprite:Sprite2D = $PlayerLocation
@onready var is_player_toggle:CheckButton = $InterfaceLayer/TileOptionsContainer/IsPlayer

var planet_name: String = "PlanetX"
var grid_width: int = 1
var grid_height: int = 1
var difficulty: int = 1
var time_until_humans: int = 100
var selected_tile: Tile
var player_start_loc: Vector2 = Vector2(0, 0)

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
	grid.connect("on_mouse_entered_tile", _on_new_tile_selected)
	#player_sprite.global_scale = Vector2(grid.tile_size, grid.tile_size)
	_update_player_pos()
	# Build Tile options grid
	
func _update_player_pos():
	var start_tile = grid.get_tile(player_start_loc.x, player_start_loc.y)
	player_sprite.global_position = start_tile.global_position
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_open_play_menu"):
		interface_layer.add_child(play_menu.instantiate())
		get_viewport().set_input_as_handled()
		
		
func _on_new_tile_selected(tile: Tile):
	if selected_tile != null:
		selected_tile.highlight_tile(false)
	selected_tile = tile
	tile.highlight_tile(true)
	tile_options_container.visible = true
	is_player_toggle.set_pressed_no_signal(player_start_loc == tile.grid_position)

func _on_planet_name_text_submitted(new_text: String) -> void:
	planet_name = new_text

func _on_grid_width_value_changed(new_value: int) -> void:
	grid_width = new_value
	grid.build_grid(grid_width, grid_height)
	_update_player_pos()
	camera.zoom_to_fit(grid.get_grid_tile_width(), grid.get_grid_tile_height())

func _on_grid_height_value_changed(new_value: int) -> void:
	grid_height = new_value
	grid.build_grid(grid_width, grid_height)
	_update_player_pos()
	camera.zoom_to_fit(grid.get_grid_tile_width(), grid.get_grid_tile_height())

func _on_difficulty_value_changed(new_value: int) -> void:
	difficulty = new_value

func _on_time_until_humans_value_changed(new_value: int) -> void:
	time_until_humans = new_value

func _on_is_player_toggled(toggled_on: bool) -> void:
	if toggled_on:
		player_start_loc = selected_tile.grid_position
		_update_player_pos()
