class_name Tile
extends Area2D

@onready var current_texture_component: Sprite2D = $CurrentTexture
@onready var highlight_texture_component: Sprite2D = $HighlightTexture

@export var ground_texture: Texture
@export var water_texture: Texture
@export var toxic_texture: Texture
@export var watered_ground_texture: Texture
@export var seed_texture: Texture
@export var tree_texture: Texture
@export var hole_texture: Texture
@export var rock_texture: Texture
@export var highlight_texture: Texture 

var grid: Grid
var grid_position: Vector2 = Vector2.ZERO
var current_state: TileGlobals.TILE_TYPE
var pending_actions: Array[TileGlobals.TILE_ACTION]

signal on_mouse_entered_tile(tile:Tile)

func blink() -> void:	
	if pending_actions.find(TileGlobals.TILE_ACTION.TOXIC) != -1:
		do_toxic_action(false)
		pending_actions.clear()
		return	
		
	if current_state == TileGlobals.TILE_TYPE.SEED:
		do_tree_action()	
		
	if current_state == TileGlobals.TILE_TYPE.WATER:
		spread_water(self)
		
			
	pending_actions.clear()

func spread_water(tile: Tile):
	var cardinal_tiles: Array[Tile] = tile._get_cardinal_tiles()
	for cardinal_tile in cardinal_tiles:
		if cardinal_tile == null:
			continue
			
		if cardinal_tile.current_state != TileGlobals.TILE_TYPE.HOLE:
			continue
			
		if cardinal_tile.pending_actions.find(TileGlobals.TILE_ACTION.TOXIC) != -1:
			continue
			
		cardinal_tile._do_water_action()
		spread_water(cardinal_tile)
		
	return

func _ready() -> void:
	highlight_texture_component.texture = highlight_texture
	highlight_tile(false)
	_do_ground_action()

func get_possible_actions() -> Array:
	var possible_actions = []
	
	if current_state == TileGlobals.TILE_TYPE.TOXIC:
		possible_actions.append(TileGlobals.TILE_ACTION.CLEAN)
	elif current_state == TileGlobals.TILE_TYPE.GROUND:
		possible_actions.append(TileGlobals.TILE_ACTION.DIG)
	elif current_state == TileGlobals.TILE_TYPE.IRRIGATED:
		possible_actions.append(TileGlobals.TILE_ACTION.DIG)
		possible_actions.append(TileGlobals.TILE_ACTION.PLANT)
	
	return possible_actions
	
func highlight_tile(is_highlighted: bool):
	if is_highlighted: 
		highlight_texture_component.modulate.a = 1
	else:
		highlight_texture_component.modulate.a = 0

func can_do_action(action_name: TileGlobals.TILE_ACTION) -> bool:	
	if current_state == TileGlobals.TILE_TYPE.ROCK:
		return false
	
	if action_name == TileGlobals.TILE_ACTION.DIG:
		return current_state == TileGlobals.TILE_TYPE.GROUND || current_state == TileGlobals.TILE_TYPE.IRRIGATED
	
	if action_name == TileGlobals.TILE_ACTION.WATER:
		return current_state == TileGlobals.TILE_TYPE.HOLE || current_state == TileGlobals.TILE_TYPE.GROUND || current_state == TileGlobals.TILE_TYPE.IRRIGATED
		
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
	elif (action_name == TileGlobals.TILE_ACTION.DIG):
		do_dig_action()
		
func _do_clean_action():
	_do_ground_action()
	pending_actions.clear()
	var diagonal_tiles: Array[Tile] = _get_diagonal_tiles()
	for diagonal_tile in diagonal_tiles:
		if diagonal_tile:
			var toxic_index = diagonal_tile.pending_actions.find(TileGlobals.TILE_ACTION.TOXIC)
			if toxic_index != -1:
				diagonal_tile.pending_actions.remove_at(toxic_index)
		
func _do_ground_action():
	current_state = TileGlobals.TILE_TYPE.GROUND
	current_texture_component.texture = ground_texture
	
func _do_plant_action():
	current_state = TileGlobals.TILE_TYPE.SEED
	current_texture_component.texture = seed_texture  
	
func _do_water_action():
	if current_state == TileGlobals.TILE_TYPE.ROCK:
		return
	current_state = TileGlobals.TILE_TYPE.WATER
	current_texture_component.texture = water_texture
	
	var surrounding_tiles: Array[Tile] = _get_surrounding_tiles()
	for tile in surrounding_tiles:
		if tile:
			tile.do_irrigate_action()
	
func do_toxic_action(spread: bool = true):
	current_state = TileGlobals.TILE_TYPE.TOXIC
	current_texture_component.texture = toxic_texture
	var diagonal_tiles: Array[Tile] = _get_diagonal_tiles()
	if spread:
		for tile in diagonal_tiles:
			if tile:
				tile.pending_actions.append(TileGlobals.TILE_ACTION.TOXIC)
	
func do_irrigate_action():
	if current_state != TileGlobals.TILE_TYPE.GROUND:
		return
	current_state = TileGlobals.TILE_TYPE.IRRIGATED
	current_texture_component.texture = watered_ground_texture
		
func do_tree_action():
	current_state = TileGlobals.TILE_TYPE.TREE
	current_texture_component.texture = tree_texture
	
func do_dig_action():
	current_state = TileGlobals.TILE_TYPE.HOLE
	current_texture_component.texture = hole_texture

func _get_surrounding_tiles() -> Array[Tile]:
	var surrounding_tiles: Array[Tile] = []
	
	var cardinal_tiles = _get_cardinal_tiles()
	for cardinal_tile in cardinal_tiles:
		surrounding_tiles.append(cardinal_tile)
		
	var diagonal_tiles = _get_diagonal_tiles()
	for diagonal_tile in diagonal_tiles:
		surrounding_tiles.append(diagonal_tile)
	
	return surrounding_tiles
	
func do_rock_action():
	current_state = TileGlobals.TILE_TYPE.ROCK
	current_texture_component.texture = rock_texture
	
	
func _get_cardinal_tiles() -> Array[Tile]:
	var cardinal_tiles: Array[Tile] = []
	cardinal_tiles.append(grid.get_tile(int(grid_position.x), int(grid_position.y + 1)))
	cardinal_tiles.append(grid.get_tile(int(grid_position.x), int(grid_position.y - 1)))
	cardinal_tiles.append(grid.get_tile(int(grid_position.x + 1), int(grid_position.y)))
	cardinal_tiles.append(grid.get_tile(int(grid_position.x - 1), int(grid_position.y)))

	return cardinal_tiles

func _get_diagonal_tiles() -> Array[Tile]:
	var diagonal_tiles: Array[Tile] = []
	diagonal_tiles.append(grid.get_tile(int(grid_position.x + 1), int(grid_position.y + 1)))
	diagonal_tiles.append(grid.get_tile(int(grid_position.x - 1), int(grid_position.y - 1)))
	diagonal_tiles.append(grid.get_tile(int(grid_position.x + 1), int(grid_position.y - 1)))
	diagonal_tiles.append(grid.get_tile(int(grid_position.x - 1), int(grid_position.y + 1)))
	
	return diagonal_tiles

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_down") and event is InputEventMouseButton:
		on_mouse_entered_tile.emit(self)
