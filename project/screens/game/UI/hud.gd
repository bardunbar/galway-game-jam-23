class_name HUD
extends Control

@onready var action_points_label:Label = $InterfaceLayer/HBoxContainer/ActionPointsValue
@onready var animation_player:AnimationPlayer = $AnimationPlayer

func update_action_points(cur_points: int, max_points: int):
	action_points_label.text = str(cur_points, "/", max_points)
	return
	
func play_fade_animation():

	animation_player.play("blink")
	return
