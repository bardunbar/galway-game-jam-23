extends Resource
class_name LevelDefinition

@export var name : String = "Planet X"
var grid_width : int = 10
var grid_height : int = 10
var start_location : Vector2i = Vector2i(0, 0);
var grid_data : Array[TileGlobals.TILE_TYPE] = []
