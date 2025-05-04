class_name Player
extends Node2D

@onready var sprite:Sprite2D

enum ACTION_TYPE {NONE, MOVE, ROTATE, ACTION}

@export var movementSpeed = 3
@export var rotationSpeed = 6
@export var low_on_action_points_amount = 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_sprite: Sprite2D = $Sprite2D

var curActionPoints
var game: GameScript
var tile_size
var curAction = ACTION_TYPE.NONE
var movementAlpha: float = 0
var gridPosition: Vector2i
var targetPosition: Vector2
var prevPosition: Vector2
var orientation: Vector2i = Vector2i(1, 0)

signal action_points_changed(new_action_points: int)
signal ready_to_blink
signal action1_updated(is_active: bool, prompt_text: String, cost: int)
signal action2_updated(is_active: bool, prompt_text: String, cost: int)

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
	set_faced_tile_highlight(true)
	
func use_action_points(count: int):
	curActionPoints = max(curActionPoints - count, 0)
	action_points_changed.emit(curActionPoints)
	if !animation_player.is_playing() && curActionPoints <= low_on_action_points_amount:
		animation_player.play("low_on_battery")
	
func finish_action():
	movementAlpha = 0
	curAction = ACTION_TYPE.NONE
	if curActionPoints <= 0:
		ready_to_blink.emit()
	else:
		set_faced_tile_highlight(true)
	
func _process(delta: float) -> void:
	processInput()
	processMovement(delta)
	return
	
func processInput() -> void:
	if (curActionPoints > 0 and curAction == ACTION_TYPE.NONE):
		var action_pressed = 0
		if Input.is_action_just_pressed("Action_1"):
			action_pressed = 1
		if Input.is_action_just_pressed("Action_2"):
			action_pressed = 2
		if action_pressed > 0:
			var facing_tile = get_facing_tile()
			if facing_tile != null:
				var possible_actions = facing_tile.get_possible_actions() as Array[TileGlobals.TILE_ACTION]
				if possible_actions.size() >= action_pressed:
					var action = possible_actions[action_pressed - 1]
					facing_tile.do_action(action)
					var action_cost = TileGlobals.tile_action_information[action].cost
					use_action_points(action_cost)
					set_faced_tile_highlight(false)
					curAction = ACTION_TYPE.ACTION
					return
			
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
					set_faced_tile_highlight(false)
					use_action_points(1)
					gridPosition = newGridPosition
					targetPosition = game.grid.get_tile(newGridPosition.x, newGridPosition.y).global_position
					curAction = ACTION_TYPE.MOVE
					
	return

func orientTo(newOrientation: Vector2):
	set_faced_tile_highlight(false)
	orientation = newOrientation
	curAction = ACTION_TYPE.ROTATE
	
	if newOrientation == Vector2.UP:
		player_sprite.rotation_degrees = 270
	elif newOrientation == Vector2.DOWN:
		player_sprite.rotation_degrees = 90
	elif newOrientation == Vector2.LEFT:
		player_sprite.rotation_degrees = 180
	elif newOrientation == Vector2.RIGHT:
		player_sprite.rotation_degrees = 0
	
func set_faced_tile_highlight(is_highlighted):
	var faced_tile = get_facing_tile()
	var has_action_1 = false
	var has_action_2 = false
	if faced_tile != null:
		faced_tile.highlight_tile(is_highlighted)
		if is_highlighted:
			var possible_actions = faced_tile.get_possible_actions() as Array[TileGlobals.TILE_ACTION]
			if possible_actions.size() >= 1:
				var action_type = possible_actions[0]
				var action_information = TileGlobals.tile_action_information[action_type]
				action1_updated.emit(true, action_information.name, action_information.cost)
				has_action_1 = true
			if possible_actions.size() >= 2:
				var action_type = possible_actions[1]
				var action_information = TileGlobals.tile_action_information[action_type]
				action2_updated.emit(true, action_information.name, action_information.cost)
				has_action_2 = true
	if !has_action_1:
		action1_updated.emit(false, "", 0)
	if !has_action_2:
		action2_updated.emit(false, "", 0)

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
	elif curAction == ACTION_TYPE.ACTION:
		movementAlpha += (delta * rotationSpeed)
		movementAlpha = clamp(movementAlpha, 0, 1)
		if movementAlpha >= 1:
			finish_action()
