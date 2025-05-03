class_name GameScript
extends Node2D

@export var play_menu: PackedScene
@export var action_points: int

@onready var interface_layer: CanvasLayer = %InterfaceLayer
@onready var grid:Grid = $Grid
@onready var player:Player = $Player
@onready var hud:HUD = $Hud

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_open_play_menu"):
		interface_layer.add_child(play_menu.instantiate())
		get_viewport().set_input_as_handled()

func _ready() -> void:
	# Initialize the player and grid
	grid.initialize(self)
	player.initialize(self)
	player.connect("action_points_changed", _on_action_points_changed)
	player.connect("readsy_to_blink", _on_ready_to_blink)
	hud.update_action_points(action_points, action_points)
	return

func _on_action_points_changed(new_action_points: int):
	hud.update_action_points(new_action_points, action_points)

func _on_ready_to_blink():
	print("Ready to blink")
	return
