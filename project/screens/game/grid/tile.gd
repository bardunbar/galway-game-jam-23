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
var current_state: TileGlobals.TILE_TYPE
var pending_actions: Array[TileGlobals.TILE_ACTION]

func blink() -> void:	
	if current_state == TileGlobals.TILE_TYPE.SEED:
		do_tree_action()
		if pending_actions.find(TileGlobals.TILE_TYPE.TOXIC) != -1:
			_do_toxic_action()
			
	pending_actions.clear()

func _ready() -> void:
	highlight_texture_component.texture = highlight_texture
	highlight_tile(false)
	_do_ground_action()

func get_possible_actions() -> Array:
	var possible_actions = []
	
	if current_state == TileGlobals.TILE_TYPE.TOXIC:
		possible_actions.append(TileGlobals.TILE_ACTION.CLEAN)
	elif current_state == TileGlobals.TILE_TYPE.GROUND:
		possible_actions.append(TileGlobals.TILE_ACTION.WATER)  
	elif current_state == TileGlobals.TILE_TYPE.IRRIGATED:
		possible_actions.append(TileGlobals.TILE_ACTION.PLANT)
	
	return possible_actions
	
func highlight_tile(is_highlighted: bool):
	if is_highlighted: 
		highlight_texture_component.modulate.a = 1
	else:
		highlight_texture_component.modulate.a = 0

func can_do_action(action_name: TileGlobals.TILE_ACTION) -> bool:	
	if action_name == TileGlobals.TILE_ACTION.WATER:
		return current_state != TileGlobals.TILE_TYPE.SEED or current_state != TileGlobals.TILE_TYPE.TREE
		
	if action_name == TileGlobals.TILE_ACTION.PLANT:
		return current_state == TileGlobals.TILE_TYPE.IRRIGATED
		
	if action_name == TileGlobals.TILE_ACTION.CLEAN:
		return current_state == TileGlobals.TILE_TYPE.TOXIC
		
	return true

func do_action(action_name: TileGlobals.TILE_ACTION) -> void:
	if !can_do_action(action_name):
		return
	elif (action_name == TileGlobals.TILE_ACTION.PLANT):
		_do_plant_action()
	elif (action_name == TileGlobals.TILE_ACTION.WATER):
		_do_water_action()
	elif (action_name == TileGlobals.TILE_ACTION.CLEAN):
		_do_clean_action()
		
func _do_clean_action():
	pass
		
func _do_ground_action():
	current_state = TileGlobals.TILE_TYPE.GROUND
	current_texture_component.texture = ground_texture
	
func _do_plant_action():
	current_state = TileGlobals.TILE_TYPE.SEED
	current_texture_component.texture = seed_texture  
	
func _do_water_action():
	current_state = TileGlobals.TILE_TYPE.WATER
	current_texture_component.texture = water_texture
	
	var surrounding_tiles: Array[Tile] = _get_surrounding_tiles()
	for tile in surrounding_tiles:
		if tile:
			tile.do_irrigate_action()
	
func _do_toxic_action():
	current_state = TileGlobals.TILE_TYPE.TOXIC
	current_texture_component.texture = toxic_texture
	
func do_irrigate_action():
	if current_state != TileGlobals.TILE_TYPE.GROUND:
		return
	current_state = TileGlobals.TILE_TYPE.IRRIGATED
	current_texture_component.texture = watered_ground_texture
	
func do_tree_action():
	current_state = TileGlobals.TILE_TYPE.TREE
	current_texture_component.texture = tree_texture

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
