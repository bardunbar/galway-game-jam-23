class_name Grid
extends Node2D

@export var tile_class: PackedScene

@export var grid_width: int = 8
@export var grid_height: int = 8
@export var tile_size: float = 64.0

func _ready() -> void:
	for i in range(grid_width):
		for j in range(grid_height):
			var tile: Tile = tile_class.instantiate() as Tile
			tile.position = position
			tile.position.x += (tile_size * j)
			tile.position.y += (tile_size * i)
			add_child(tile)
