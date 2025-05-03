class_name Player
extends Node2D

@onready var sprite:Sprite2D

var game: GameScript
var tile_size = 100
var speed = 3
var isMoving = false
var movementAlpha: float = 0
var gridPosition: Vector2i
var targetPosition: Vector2
var prevPosition: Vector2
var orientation: Vector2i = Vector2i(1, 0)

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
	
func _process(delta: float) -> void:
	processInput()
	processMovement(delta)
	return
	
func processInput() -> void:
	if not isMoving:
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
					gridPosition = newGridPosition
					targetPosition = game.grid.get_tile(newGridPosition.x, newGridPosition.y).global_position
					isMoving = true
					
	return

func orientTo(newOrientation: Vector2):
	# TODO: rotate sprite
	orientation = newOrientation
	return
	
func processMovement(delta: float) -> void:
	if isMoving:
		movementAlpha += (delta * speed)
		movementAlpha = clamp(movementAlpha, 0, 1)
		var newLoc = ((targetPosition - prevPosition) * movementAlpha) + prevPosition
		global_position = newLoc
		if movementAlpha >= 1:
			prevPosition = targetPosition
			movementAlpha = 0
			isMoving = false
