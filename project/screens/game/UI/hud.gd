class_name HUD
extends Control

@onready var action_points_label:Label = $InterfaceLayer/ActionPointsContainer/ActionPointsValue
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var action1_container:HBoxContainer = $InterfaceLayer/Prompts/Action1Container
@onready var action1_prompt:Label = $InterfaceLayer/Prompts/Action1Container/Action1Prompt
@onready var action1_cost:Label = $InterfaceLayer/Prompts/Action1Container/Action1Cost
@onready var action2_container:HBoxContainer = $InterfaceLayer/Prompts/Action2Container
@onready var action2_prompt:Label = $InterfaceLayer/Prompts/Action2Container/Action2Prompt
@onready var action2_cost:Label = $InterfaceLayer/Prompts/Action2Container/Action2Cost

func update_action_points(cur_points: int, max_points: int):
	action_points_label.text = str(cur_points, "/", max_points)
	return
	
func update_action_1_prompt(is_active: bool, prompt_text: String, cost: int):
	action1_container.visible = is_active
	if is_active:
		action1_prompt.text = prompt_text
		action1_cost.text = str(cost)
	return
		
func update_action_2_prompt(is_active: bool, prompt_text: String, cost: int):
	action2_container.visible = is_active
	if is_active:
		action2_prompt.text = prompt_text
		action2_cost.text = str(cost)
	return
	
func play_fade_animation():

	animation_player.play("blink")
	return
