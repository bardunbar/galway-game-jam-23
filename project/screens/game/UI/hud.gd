class_name HUD
extends Control

@onready var action_points_label:Label = $InterfaceLayer/ActionPointsContainer/ActionPointsValue
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var action1_container:HBoxContainer = $InterfaceLayer/Action1Container
@onready var action1_prompt:Label = $InterfaceLayer/Action1Container/Action1Prompt
@onready var action1_cost:Label = $InterfaceLayer/Action1Container/Action1Cost

signal on_mid_blink

func update_action_points(cur_points: int, max_points: int):
	action_points_label.text = str(cur_points, "/", max_points)
	return
	
func update_action_1_prompt(is_active: bool, prompt_text: String, cost: int):
	action1_container.visible = is_active
	if is_active:
		action1_prompt.text = prompt_text
		action1_cost.text = str(cost)
	return
	
func play_fade_animation():
	if !animation_player.is_playing():
		animation_player.play("blink")
		
func _emit_mid_blink():
	emit_signal("on_mid_blink")
