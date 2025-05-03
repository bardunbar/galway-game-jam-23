class_name Grid
extends Node2D

@onready var debug_display: Node2D = $Debug

@export var tile_class: PackedScene

@export var grid_width: int = 8
@export var grid_height: int = 8
@export var tile_size: float = 64.0
@export var startingGridLocation: Vector2 = Vector2(3, 3)

var game: GameScript
var current_tiles: Array[Array]

func get_tile(x: int, y: int) -> Tile:
	var row = current_tiles[y]
	if (row):
		return row[x]
	return null
		
func doAction(x: int, y: int, action_name: String):
	var tile: Tile = get_tile(x, y)
	if tile and tile.can_do_action(action_name):
		tile.do_action(action_name)
	
func getStartingLocation() -> Vector2:
	return get_tile(startingGridLocation.x, startingGridLocation.y).global_position
	
func canMove(x: int, y: int) -> bool:
	# TODO: check for tile type (i.e. tree/rock)
	return get_tile(x, y) != null
		
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
			
			current_tiles[i].append(tile)
			
			add_child(tile)

func _ready() -> void:
	if debug_display:
		debug_display.queue_free()
