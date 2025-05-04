extends Node

var cur_testing_level = null
var test_passed = false

enum TILE_TYPE {
	GROUND, 
	SEED,
	TREE,
	WATER,
	IRRIGATED,
	TOXIC,
	CLEAN,
	ROCK,
	HOLE,
}

enum TILE_ACTION {
	PLANT,
	CLEAN,
	WATER,
	DIG,
	TOXIC,
}

class TileActionInformation:
	var name
	var cost
	
	func _init(in_name, in_cost):
		name = in_name
		cost = in_cost

var tile_defintions : TileDefinitions = preload("res://resources/tile_definitions.tres")

var tile_action_information: Dictionary[TILE_ACTION, TileActionInformation] = {
	TILE_ACTION.CLEAN: TileActionInformation.new("clean", 2),
	TILE_ACTION.WATER: TileActionInformation.new("water", 2),
	TILE_ACTION.PLANT: TileActionInformation.new("plant", 2),
	TILE_ACTION.DIG: TileActionInformation.new("dig", 2),
}

var tile_oxygen_scores: Dictionary[TILE_TYPE, float] = {
	TILE_TYPE.TREE: 10.0,
}

var levels = [
	"Tutorial",
	"WalledInByTrees",
	"FirstDig",
	"FirstToxins",
	"ToxinCleanup"
]
