extends Node

enum TILE_TYPE {
	GROUND, 
	SEED,
	TREE,
	WATER,
	IRRIGATED,
	TOXIC,
	CLEAN,
}

enum TILE_ACTION {
	PLANT,
	CLEAN,
	WATER,
}

class TileActionInformation:
	var name
	var cost
	
	func _init(in_name, in_cost):
		name = in_name
		cost = in_cost

var tile_action_information: Dictionary[TILE_ACTION, TileActionInformation] = {
	TILE_ACTION.CLEAN: TileActionInformation.new("clean", 2),
	TILE_ACTION.WATER: TileActionInformation.new("water", 2),
	TILE_ACTION.PLANT: TileActionInformation.new("plant", 2),
}
