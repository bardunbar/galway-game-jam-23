class_name Grid
extends Node2D

@export var tile_class: PackedScene

@export var grid_width: int
@export var grid_height: int

func _ready() -> void:
	for i in range(grid_width):
		for j in range(grid_height):
			var tile: Tile = tile_class.instantiate() as Tile
			tile.position = position
			tile.position.x += (64 * j)
			tile.position.y += (64 * i)
			add_child(tile)
