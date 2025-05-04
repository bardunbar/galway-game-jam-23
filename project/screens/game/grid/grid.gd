class_name Grid
extends Node2D

@export var tile_class: PackedScene

@export var grid_width: int = 8
@export var grid_height: int = 8
@export var tile_size: float = 64.0
@export var startingGridLocation: Vector2 = Vector2(3, 3)

var game: GameScript
var current_tiles: Array[Array]

signal on_mouse_entered_tile(tile:Tile)

func make_random_tiles(num_tiles: int, tile_action: TileGlobals.TILE_TYPE):
	for i in range(num_tiles):
		var random_x = randi_range(0, grid_width - 1)
		var random_y = randi_range(0, grid_height - 1)
		
		var tile: Tile = get_tile(random_x, random_y)
		if tile_action == TileGlobals.TILE_TYPE.TOXIC:
			tile.do_toxic_action()
		elif tile_action == TileGlobals.TILE_TYPE.WATER:
			tile._do_water_action()
		elif tile_action == TileGlobals.TILE_TYPE.ROCK:
			tile.do_rock_action()

func blink() -> void:
	for row in current_tiles:
		for object in row:
			var tile: Tile = object as Tile
			tile.blink()
			
func get_num_trees() -> int:
	return get_tiles_of_type(TileGlobals.TILE_TYPE.TREE).size()
	
func get_num_toxic() -> int:
	return get_tiles_of_type(TileGlobals.TILE_TYPE.TOXIC).size()
	
func get_tiles_of_type(tile_type: TileGlobals.TILE_TYPE):
	var tiles: Array[Tile]
	for row in current_tiles:
		for object in row:
			var tile: Tile = object as Tile
			if tile.current_state == tile_type:
				tiles.append(tile)
				
	return tiles
	

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
	if !is_valid_tile_loc(x, y):
		return false
		
	var tile: Tile = get_tile(x, y)
	if tile.current_state == TileGlobals.TILE_TYPE.TREE || tile.current_state == TileGlobals.TILE_TYPE.ROCK:
		return false
	
	return true
	
func is_valid_tile_loc(x: int, y: int) -> bool:
	return x >= 0 and x < grid_width and y >= 0 and y < grid_height
		
func initialize(inGame: GameScript):
	game = inGame
	build_grid(grid_width, grid_height)
	
func build_grid(width, height):
	grid_width = width
	grid_height = height
	
	var cur_height = current_tiles.size()
	var cur_width = 0
	if cur_height > 0:
		cur_width = current_tiles[0].size()
	
	if cur_height < height:
		for i in range(height - cur_height):
			current_tiles.append(Array())
	else:
		for i in range(cur_height - height):
			var row_to_remove = current_tiles[current_tiles.size() - 1]
			for j in range(cur_width):
				if(row_to_remove.size() > j):
					var tile_to_remove: Tile = row_to_remove[j]
					tile_to_remove.queue_free()
			row_to_remove.clear()
			current_tiles.remove_at(current_tiles.size() - 1)
			
		
	position.x = -(width * tile_size)/2
	position.y = -(height * tile_size)/2
	
	for i in range(height):
		for j in range(width):
			var tile: Tile
			if current_tiles[i].size() > j:
				tile = current_tiles[i][j]
			if tile == null:
				tile = tile_class.instantiate() as Tile
				tile.connect("on_mouse_entered_tile", _on_mouse_entered_tile)
				current_tiles[i].append(tile)
				add_child(tile)
			tile.position.x = (tile_size * (j + 0.5))
			tile.position.y = (tile_size * (i + 0.5))
			tile.grid_position = Vector2(j, i)
			tile.grid = self
		if cur_width > width:
			for j in range(width, cur_width):
				current_tiles[i][current_tiles[i].size() - 1].queue_free()
				current_tiles[i].remove_at(current_tiles[i].size() - 1)
			

func get_grid_tile_width():
	return grid_width * tile_size

func get_grid_tile_height():
	return grid_height * tile_size
	
func _on_mouse_entered_tile(tile:Tile):
	on_mouse_entered_tile.emit(tile)
