class_name Grid
extends Node2D

@onready var debug_display: Node2D = $Debug

@export var tile_class: PackedScene

@export var grid_width: int = 8
@export var grid_height: int = 8
@export var tile_size: float = 64.0

var current_tiles: Array[Array]

func get_tile(x: int, y: int):
	var row = current_tiles[y]
	if (row):
		return row[x]

func _ready() -> void:
	if debug_display:
		debug_display.queue_free()
	
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
