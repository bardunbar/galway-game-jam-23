extends Resource
class_name LevelDefinition

@export var name : String = "Planet X"
@export var grid_width : int = 10
@export var grid_height : int = 10
@export var start_location : Vector2i = Vector2i(0, 0);
@export var grid_data : Array[TileGlobals.TILE_TYPE] = []
