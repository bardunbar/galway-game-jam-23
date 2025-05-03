class_name HUD
extends Control

@onready var action_points_label:Label = $InterfaceLayer/HBoxContainer/ActionPointsValue

func update_action_points(cur_points: int, max_points: int):
	action_points_label.text = str(cur_points, "/", max_points)
	return
