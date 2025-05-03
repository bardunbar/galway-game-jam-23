class_name HUD
extends Control

@onready var action_points_label:Label = $InterfaceLayer/ActionPointsContainer/ActionPointsValue
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var action1_container:HBoxContainer = $InterfaceLayer/Action1Container
@onready var action1_prompt:Label = $InterfaceLayer/Action1Container/Action1Prompt

func update_action_points(cur_points: int, max_points: int):
	action_points_label.text = str(cur_points, "/", max_points)
	return
	
func update_action_1_prompt(is_active: bool, prompt_text: String):
	action1_container.visible = is_active
	if is_active:
		action1_prompt.text = prompt_text
	return
	
func play_fade_animation():

	animation_player.play("blink")
	return
