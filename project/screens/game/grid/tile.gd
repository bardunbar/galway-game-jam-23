class_name Tile
extends Node2D

@onready var current_texture: Sprite2D = $Sprite2D

@export var ground_texture: Texture
@export var water_texture: Texture
@export var toxic_texture: Texture

func _ready() -> void:
	current_texture.texture = ground_texture
	
func do_action(action_name: String) -> void:
	if (action_name == "ground"):
		_do_ground_action()
	elif (action_name == "water"):
		_do_water_action()
	elif (action_name == "toxic"):
		_do_toxic_action()
		
func _do_ground_action():
	current_texture.texture = ground_texture
	
func _do_water_action():
	current_texture.texture = water_texture
	
func _do_toxic_action():
	current_texture.texture = toxic_texture
