class_name GameScript
extends Node2D

@export var play_menu: PackedScene

@export var action_points: int
@export var starting_level : LevelDefinition

@onready var interface_layer: CanvasLayer = %InterfaceLayer
@onready var grid:Grid = $Grid
@onready var player:Player = $Player
@onready var hud:HUD = $Hud
@onready var camera:GameCamera = $Camera2D
@onready var blink_sfx:AudioStreamPlayer2D = $BlinkSFX

var cur_level_index = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_open_play_menu"):
		interface_layer.add_child(play_menu.instantiate())
		get_viewport().set_input_as_handled()

func _ready() -> void:
	# Initialize the player and grid
	if TileGlobals.cur_testing_level:
		setup_level(TileGlobals.cur_testing_level)
	else:
		var first_level_name = TileGlobals.levels[0]
		setup_level_from_name(first_level_name)
	
	# initialize player connections
	player.connect("action_points_changed", _on_action_points_changed)
	player.connect("ready_to_blink", _on_ready_to_blink)
	player.connect("action1_updated", _on_action1_updated)
	player.connect("action2_updated", _on_action2_updated)
	
	# initialize hud and connections
	hud.on_mid_blink.connect(_on_mid_blink)
	
	# initialize camera
	camera.zoom_to_fit(grid.get_grid_tile_width(), grid.get_grid_tile_height())
	
	# initialize grid connections
	grid.connect("oxygen_updated", _on_oxygen_updated)
	grid.connect("cycles_updated", _on_cycles_updated)


func setup_demo_grid() -> void:
	grid.initialize(self)
	grid.make_random_tiles(3, TileGlobals.TILE_TYPE.TOXIC)
	grid.make_random_tiles(1, TileGlobals.TILE_TYPE.WATER)
	grid.make_random_tiles(3, TileGlobals.TILE_TYPE.ROCK)

func go_to_next_level():
	cur_level_index += 1
	if TileGlobals.levels.size() > cur_level_index:
		var next_level_name = TileGlobals.levels[cur_level_index]
		setup_level_from_name(next_level_name)
		
func setup_level_from_name(level_name: String):
	var level: LevelDefinition = load(str("res://resources/levels/", level_name, ".tres")) as LevelDefinition
	setup_level(level)
	
func setup_level(level_definition: LevelDefinition = null) -> void:
	if level_definition == null:
		setup_demo_grid()
	else:
		grid.initialize(self, level_definition)
	
	player.initialize(self)
	grid.first_cycle()
	hud.update_action_points(action_points, action_points)

func _on_action_points_changed(new_action_points: int):
	hud.update_action_points(new_action_points, action_points)
	if new_action_points == 0:
		_on_ready_to_blink()

func _on_oxygen_updated(new_oxygen_level: float) -> void:
	hud.update_oxygen(new_oxygen_level)

func _on_cycles_updated(current_cycles: int, target_cycles: int) -> void:
	hud.update_cycle_counts(current_cycles, target_cycles)
	
	if current_cycles == target_cycles:
		_handle_level_over()

func _on_ready_to_blink():
	hud.play_fade_animation()
	
func _on_mid_blink():
	player.curActionPoints = action_points
	player.reset()
	hud.update_action_points(action_points, action_points)
	grid.blink()
	blink_sfx.play()

func _on_action1_updated(is_active: bool, prompt_text: String, cost: int):
	hud.update_action_1_prompt(is_active, prompt_text, cost)
	
func _on_action2_updated(is_active: bool, prompt_text: String, cost: int):
	hud.update_action_2_prompt(is_active, prompt_text, cost)

func _handle_level_over():
	grid.update_oxygen_level()
	
	var success : bool = grid.oxygen_level >= grid.target_oxygen_level
	if TileGlobals.cur_testing_level:
		_return_to_puzzle_editor(success)

func _return_to_puzzle_editor(success: bool):
	TileGlobals.test_passed = success
	get_tree().change_scene_to_file("res://screens/puzzle_editor/puzzle_editor.tscn")
