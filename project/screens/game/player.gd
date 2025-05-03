class_name Player
extends Node2D

@onready var sprite:Sprite2D

enum ACTION_TYPE {NONE, MOVE, ROTATE, ACTION}

var curActionPoints
var game: GameScript
var tile_size
var movementSpeed = 3
var rotationSpeed = 6
var curAction = ACTION_TYPE.NONE
var movementAlpha: float = 0
var gridPosition: Vector2i
var targetPosition: Vector2
var prevPosition: Vector2
var orientation: Vector2i = Vector2i(1, 0)

signal action_points_changed(new_action_points: int)
signal ready_to_blink

func _ready() -> void:
	return
	
func initialize(inGame: GameScript):
	game = inGame
	
	# Set starting location
	gridPosition = game.grid.startingGridLocation
	global_position = game.grid.getStartingLocation()
	targetPosition = global_position
	prevPosition = global_position
	
	tile_size = game.grid.tile_size
	curActionPoints = game.action_points
	set_faced_tile_highlight()
	
func use_action_points(count: int):
	curActionPoints = max(curActionPoints - count, 0)
	action_points_changed.emit(curActionPoints)
	
func finish_action():
	movementAlpha = 0
	curAction = ACTION_TYPE.NONE
	if curActionPoints <= 0:
		ready_to_blink.emit()
	else:
		set_faced_tile_highlight()
	
func _process(delta: float) -> void:
	processInput()
	processMovement(delta)
	return
	
func processInput() -> void:
	if (curActionPoints > 0 and curAction == ACTION_TYPE.NONE):
		var movementDirection: Vector2i = Vector2i.ZERO
		if Input.is_action_pressed("move_right"):
			movementDirection.x = 1
		elif Input.is_action_pressed("move_left"):
			movementDirection.x = -1
		elif Input.is_action_pressed("move_down"):
			movementDirection.y = 1
		elif Input.is_action_pressed("move_up"):
			movementDirection.y = -1
		if movementDirection != Vector2i.ZERO:
			if movementDirection != orientation:
				orientTo(movementDirection)
			else:
				var newGridPosition = gridPosition + movementDirection
				if game.grid.canMove(newGridPosition.x, newGridPosition.y):
					clear_faced_tile_highlight()
					use_action_points(1)
					gridPosition = newGridPosition
					targetPosition = game.grid.get_tile(newGridPosition.x, newGridPosition.y).global_position
					curAction = ACTION_TYPE.MOVE
					
	return

func orientTo(newOrientation: Vector2):
	# TODO: rotate sprite
	clear_faced_tile_highlight()
	orientation = newOrientation
	curAction = ACTION_TYPE.ROTATE
	return
	
func clear_faced_tile_highlight():
	return
	
func set_faced_tile_highlight():
	return

func get_facing_tile():
	var faced_tile_position = gridPosition + orientation
	return game.grid.get_tile(faced_tile_position.x, faced_tile_position.y)
	
func processMovement(delta: float) -> void:
	if curAction == ACTION_TYPE.MOVE:
		movementAlpha += (delta * movementSpeed)
		movementAlpha = clamp(movementAlpha, 0, 1)
		var newLoc = ((targetPosition - prevPosition) * movementAlpha) + prevPosition
		global_position = newLoc
		if movementAlpha >= 1:
			prevPosition = targetPosition
			finish_action()
	elif curAction == ACTION_TYPE.ROTATE:
		movementAlpha += (delta * rotationSpeed)
		movementAlpha = clamp(movementAlpha, 0, 1)
		if movementAlpha >= 1:
			finish_action()
