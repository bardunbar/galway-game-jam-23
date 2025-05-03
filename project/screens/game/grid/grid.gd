class_name Grid
extends Node2D

@export var tile_class: PackedScene

@export var grid_width: int = 8
@export var grid_height: int = 8
@export var tile_size: float = 64.0
@export var startingGridLocation: Vector2 = Vector2(3, 3)

var game: GameScript
var current_tiles: Array[Array]

func blink() -> void:
	for row in current_tiles:
		for object in row:
			var tile: Tile = object as Tile
			tile.blink()
			
func get_num_trees() -> int:
	var num_trees: int = 0
	for row in current_tiles:
		for object in row:
			var tile: Tile = object as Tile
			if tile.current_state == TileGlobals.TILE_TYPE.TREE:
				num_trees += 1		
	return num_trees

func get_tile(x: int, y: int) -> Tile:
	if !is_valid_tile_loc(x, y):
		return null
	var row = current_tiles[y]
	if (row):
		return row[x]
	return null
		
func doAction(x: int, y: int, action_name: TileGlobals.TILE_ACTION):
	var tile: Tile = get_tile(x, y)
	if tile and tile.can_do_action(action_name):
		tile.do_action(action_name)
	
func getStartingLocation() -> Vector2:
	return get_tile(startingGridLocation.x, startingGridLocation.y).global_position
	
func canMove(x: int, y: int) -> bool:
	return is_valid_tile_loc(x, y)
	
func is_valid_tile_loc(x: int, y: int) -> bool:
	return x >= 0 and x < grid_width and y >= 0 and y < grid_height
		
func initialize(inGame: GameScript):
	game = inGame
	for i in range(grid_width):
		current_tiles.append(Array())
	
	for i in range(grid_width):
		for j in range(grid_height):
			var tile: Tile = tile_class.instantiate() as Tile
			tile.position = position
			tile.position.x += (tile_size * j)
			tile.position.y += (tile_size * i)
			tile.grid_position = Vector2(j, i)
			tile.grid = self
			
			current_tiles[i].append(tile)
			add_child(tile)
