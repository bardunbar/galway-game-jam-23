extends Node2D

var gridSize = 100
var speed = 3
var isMoving = false
var movementAlpha: float = 0
var movementDirection: Vector2i = Vector2i.ZERO
var targetPosition: Vector2
var prevPosition: Vector2

func _ready() -> void:
	# TODO: Set starting position
	targetPosition = global_position
	prevPosition = global_position
	return
	
func _process(delta: float) -> void:
	processInput()
	processMovement(delta)
	return
	
func processInput() -> void:
	if not isMoving:
		movementDirection = Vector2i.ZERO
		if Input.is_action_pressed("move_right"):
			targetPosition.x += gridSize
			isMoving = true
		if Input.is_action_pressed("move_left"):
			targetPosition.x -= gridSize
			isMoving = true
		if Input.is_action_pressed("move_down"):
			targetPosition.y += gridSize
			isMoving = true
		if Input.is_action_pressed("move_up"):
			targetPosition.y -= gridSize
			isMoving = true
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
