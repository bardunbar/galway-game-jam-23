class_name GameScript
extends Node2D

@export var play_menu: PackedScene
@export var action_points: int

@onready var interface_layer: CanvasLayer = %InterfaceLayer
@onready var grid:Grid = $Grid
@onready var player:Player = $Player
@onready var hud:HUD = $Hud
@onready var camera:GameCamera = $Camera2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_open_play_menu"):
		interface_layer.add_child(play_menu.instantiate())
		get_viewport().set_input_as_handled()

func _ready() -> void:
	# Initialize the player and grid
	grid.initialize(self)
	camera.zoom_to_fit(grid.get_grid_tile_width(), grid.get_grid_tile_height())
	player.connect("action_points_changed", _on_action_points_changed)
	player.connect("ready_to_blink", _on_ready_to_blink)
	player.connect("action1_updated", _on_action1_updated)
	player.connect("action2_updated", _on_action2_updated)
	player.initialize(self)
	hud.update_action_points(action_points, action_points)
	hud.on_mid_blink.connect(_on_mid_blink)
	grid.make_random_tiles(3, TileGlobals.TILE_TYPE.TOXIC)
	grid.make_random_tiles(1, TileGlobals.TILE_TYPE.WATER)
	grid.make_random_tiles(3, TileGlobals.TILE_TYPE.ROCK)
	grid.connect("oxygen_updated", _on_oxygen_updated)
	grid.update_oxygen_level()
	return

func _on_action_points_changed(new_action_points: int):
	hud.update_action_points(new_action_points, action_points)
	if new_action_points == 0:
		_on_ready_to_blink()

func _on_oxygen_updated(new_oxygen_level: float) -> void:
	hud.update_oxygen(new_oxygen_level)

func _on_ready_to_blink():
	hud.play_fade_animation()
	
func _on_mid_blink():
	player.curActionPoints = action_points
	hud.update_action_points(action_points, action_points)
	grid.blink()

func _on_action1_updated(is_active: bool, prompt_text: String, cost: int):
	hud.update_action_1_prompt(is_active, prompt_text, cost)
	
func _on_action2_updated(is_active: bool, prompt_text: String, cost: int):
	hud.update_action_2_prompt(is_active, prompt_text, cost)
