class_name Tile
extends Node2D

@onready var current_texture_component: Sprite2D = $CurrentTexture
@onready var highlight_texture_component: Sprite2D = $HighlightTexture

@export var ground_texture: Texture
@export var water_texture: Texture
@export var toxic_texture: Texture
@export var watered_ground_texture: Texture
@export var seed_texture: Texture
@export var tree_texture: Texture
@export var highlight_texture: Texture 

var grid: Grid
var grid_position: Vector2 = Vector2.ZERO
var current_state: String
var pending_actions: Array[String]

func blink() -> void:	
	if current_state == "plant":
		if pending_actions.is_empty():
			_do_plant_action()
		elif pending_actions.find("toxic") > 0:
			_do_toxic_action()
		
	pending_actions.clear()

func _ready() -> void:
	highlight_texture_component.texture = highlight_texture
	highlight_tile(false)
	_do_ground_action()

func get_possible_actions() -> Array:
	var possible_actions = []
	
	if current_state == "toxic":
		possible_actions.append("clean")
	elif current_state == "ground":
		possible_actions.append("water")
		possible_actions.append("plant")
	
	return possible_actions
	
func highlight_tile(is_highlighted: bool):
	if is_highlighted: 
		highlight_texture_component.modulate.a = 1
	else:
		highlight_texture_component.modulate.a = 0

func can_do_action(action_name: String) -> bool:
	return true

func do_action(action_name: String) -> void:
	if !can_do_action(action_name):
		return
	
	if (action_name == "ground"):
		_do_ground_action()
	elif (action_name == "plant"):
		_do_plant_action()
	elif (action_name == "water"):
		_do_water_action()
	elif (action_name == "irrigate"):
		_do_irrigate_action()
	elif (action_name == "toxic"):
		_do_toxic_action()
		
func _do_ground_action():
	current_state = "ground"
	current_texture_component.texture = ground_texture
	
func _do_plant_action():
	current_state = "plant"
	pass
	
func _do_water_action():
	current_state = "water"
	current_texture_component.texture = water_texture
	
	var surrounding_tiles: Array[Tile] = _get_surrounding_tiles()
	for tile in surrounding_tiles:
		if tile:
			tile.do_action("irrigate")
	
func _do_toxic_action():
	current_state = "toxic"
	current_texture_component.texture = toxic_texture
	
func _do_irrigate_action():
	current_state = "wet"
	current_texture_component.texture = watered_ground_texture

func _get_surrounding_tiles() -> Array[Tile]:
	var surrounding_tiles: Array[Tile] = []
	
	surrounding_tiles.append(grid.get_tile(grid_position.x, grid_position.y + 1))
	surrounding_tiles.append(grid.get_tile(grid_position.x, grid_position.y - 1))
	surrounding_tiles.append(grid.get_tile(grid_position.x + 1, grid_position.y + 1))
	surrounding_tiles.append(grid.get_tile(grid_position.x - 1, grid_position.y - 1))
	surrounding_tiles.append(grid.get_tile(grid_position.x + 1, grid_position.y))
	surrounding_tiles.append(grid.get_tile(grid_position.x - 1, grid_position.y))
	surrounding_tiles.append(grid.get_tile(grid_position.x + 1, grid_position.y - 1))
	surrounding_tiles.append(grid.get_tile(grid_position.x - 1, grid_position.y + 1))
	
	return surrounding_tiles
