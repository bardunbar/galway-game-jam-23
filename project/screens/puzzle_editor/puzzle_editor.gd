class_name PuzzleEditor
extends Node2D

@export var play_menu: PackedScene
@export var tile_button_class: PackedScene
@onready var grid:Grid = $Grid
@onready var interface_layer: CanvasLayer = %InterfaceLayer
@onready var camera:GameCamera = $Camera2D
@onready var tile_options_container:VBoxContainer = $InterfaceLayer/TileOptionsContainer
@onready var tile_options_grid:GridContainer = $InterfaceLayer/TileOptionsContainer/TileGrid
@onready var player_sprite:Sprite2D = $PlayerLocation
@onready var is_player_toggle:CheckButton = $InterfaceLayer/TileOptionsContainer/IsPlayer
@onready var planet_name_input:LineEdit = $InterfaceLayer/VBoxContainer/PlanetName
@onready var grid_width_rotator:Rotator = $InterfaceLayer/VBoxContainer/GridWidth
@onready var grid_height_rotator:Rotator = $InterfaceLayer/VBoxContainer/GridHeight
@onready var difficutly_rotator:Rotator = $InterfaceLayer/VBoxContainer/Difficulty
@onready var time_until_humans_rotator:Rotator = $InterfaceLayer/VBoxContainer/TimeUntilHumans
@onready var test_label:Label = $InterfaceLayer/VBoxContainer/TestLabel
@onready var save_button:Button = %SaveButton

var planet_name: String = "PlanetX"
var grid_width: int = 1
var grid_height: int = 1
var difficulty: int = 1
var time_until_humans: int = 100
var selected_tile: Tile
var player_start_loc: Vector2 = Vector2(0, 0)
var cur_tile_button: TileButton
var test_passed = false
var ignore_testing = true

func _generate_level() -> LevelDefinition:
	var level: LevelDefinition = grid.export_to_resource()
	level.start_location = Vector2i(player_start_loc.x, player_start_loc.y)
	level.name = planet_name
	level.difficulty = difficulty
	level.time_until_humans = time_until_humans
	return level

func _on_test_button_pressed() -> void:
	TileGlobals.cur_testing_level = _generate_level()
	TileGlobals.test_passed = false
	get_tree().change_scene_to_file("res://screens/game/game_scene.tscn")

func _on_save_button_pressed() -> void:
	var resource = _generate_level()
	var path : String
	if OS.has_feature("editor"):
		path = "res://resources/levels/%s.tres" % planet_name
	else:
		path = "user://levels/%s.tres" % planet_name
	var error := ResourceSaver.save(resource, path)
	if error:
		print("An error happened while saving data: ", error)

func _ready() -> void:
	if TileGlobals.cur_testing_level != null:
		_setup_level(TileGlobals.cur_testing_level)
		TileGlobals.cur_testing_level = null
		test_passed = TileGlobals.test_passed
		if test_passed:
			test_label.text = "Test Passed"
		else:
			test_label.text = "Test Failed"
	
	if not ignore_testing:
		save_button.disabled = not test_passed
		
	_update_grid()
	grid.connect("on_mouse_entered_tile", _on_new_tile_selected)
	# Build Tile options grid
	for tile_type in TileGlobals.tile_defintions.texture_map:
		var tile_button:TileButton = tile_button_class.instantiate() as TileButton
		tile_button.set_type(tile_type)
		tile_button.connect("on_tile_button_highlighted", _on_tile_button_highlighted)
		tile_options_grid.add_child(tile_button)

	save_button.visible = not OS.has_feature("web")

func _update_grid():
	grid.build_grid(grid_width, grid_height, false)
	camera.zoom_to_fit(grid.get_grid_tile_width(), grid.get_grid_tile_height())
	_update_player_pos()

func _update_player_pos():
	var start_tile = grid.get_tile(player_start_loc.x, player_start_loc.y)
	player_sprite.global_position = start_tile.global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_open_play_menu"):
		interface_layer.add_child(play_menu.instantiate())
		get_viewport().set_input_as_handled()
	var movementDirection: Vector2i = Vector2i.ZERO
	if event.is_action_pressed("move_right"):
		movementDirection.x = 1
	elif event.is_action_pressed("move_left"):
		movementDirection.x = -1
	elif event.is_action_pressed("move_down"):
		movementDirection.y = 1
	elif event.is_action_pressed("move_up"):
		movementDirection.y = -1
	if movementDirection != Vector2i.ZERO:
		var new_pos = Vector2.ZERO
		if selected_tile != null:
			new_pos = selected_tile.grid_position + Vector2(movementDirection.x, movementDirection.y)
		if grid.is_valid_tile_loc(new_pos.x, new_pos.y):
			_on_new_tile_selected(grid.get_tile(new_pos.x, new_pos.y))
		
func _on_new_tile_selected(tile: Tile):
	if selected_tile != null:
		selected_tile.highlight_tile(false)
	selected_tile = tile
	tile.highlight_tile(true)
	tile_options_container.visible = true
	is_player_toggle.set_pressed_no_signal(player_start_loc == tile.grid_position)
	if cur_tile_button == null or cur_tile_button.tile_type != selected_tile.current_state:
		if cur_tile_button != null:
			cur_tile_button.set_highlighted(false)
		for tile_button in tile_options_grid.get_children():
			if tile_button.tile_type == selected_tile.current_state:
				tile_button.set_highlighted(true)
				cur_tile_button = tile_button

func _on_tile_button_highlighted(tile_button:TileButton):
	if cur_tile_button != null:
		cur_tile_button.set_highlighted(false)
	cur_tile_button = tile_button
	selected_tile.set_tile_type(cur_tile_button.tile_type)
	_mark_needs_testing()

func _on_planet_name_text_submitted(new_text: String) -> void:
	planet_name = new_text
	
	var planet_path : String
	if OS.has_feature("editor"):
		planet_path = "res://resources/levels/%s.tres" % planet_name
	else:
		planet_path = "user://levels/%s.tres" % planet_name
	
	if ResourceLoader.exists(planet_path):
		var definition : LevelDefinition = load(planet_path)
		_setup_level(definition)

func _setup_level(level: LevelDefinition):
	grid.import_from_resource(level)
	planet_name = level.name
	grid_width = level.grid_width
	grid_height = level.grid_height
	difficulty = level.difficulty
	time_until_humans = level.time_until_humans
	player_start_loc = Vector2(level.start_location.x, level.start_location.y)
	
	planet_name_input.text = planet_name
	grid_width_rotator.set_value(grid_width)
	grid_height_rotator.set_value(grid_height)
	difficutly_rotator.set_value(difficulty)
	time_until_humans_rotator.set_value(time_until_humans)

func _on_grid_width_value_changed(new_value: int) -> void:
	grid_width = new_value
	_update_grid()
	_mark_needs_testing()

func _on_grid_height_value_changed(new_value: int) -> void:
	grid_height = new_value
	_update_grid()
	_mark_needs_testing()

func _on_difficulty_value_changed(new_value: int) -> void:
	difficulty = new_value

func _on_time_until_humans_value_changed(new_value: int) -> void:
	time_until_humans = new_value
	_mark_needs_testing()

func _on_is_player_toggled(toggled_on: bool) -> void:
	if toggled_on:
		player_start_loc = selected_tile.grid_position
		_update_player_pos()
		_mark_needs_testing()

func _mark_needs_testing():
	test_label.text = "Needs Testing"
	test_passed = false
	if not ignore_testing:
		save_button.disabled = true
