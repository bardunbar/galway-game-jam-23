class_name HUD
extends Control

@onready var action_points_label:Label = $InterfaceLayer/ActionPointsContainer/ActionPointsValue
@onready var oxygen_value_label:Label = $InterfaceLayer/ScoresContainer/OxygenContainer/OxygenValue
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var action1_container:HBoxContainer = $InterfaceLayer/Prompts/Action1Container
@onready var action1_prompt:Label = $InterfaceLayer/Prompts/Action1Container/Action1Prompt
@onready var action1_cost:Label = $InterfaceLayer/Prompts/Action1Container/Action1Cost
@onready var action2_container:HBoxContainer = $InterfaceLayer/Prompts/Action2Container
@onready var action2_prompt:Label = $InterfaceLayer/Prompts/Action2Container/Action2Prompt
@onready var action2_cost:Label = $InterfaceLayer/Prompts/Action2Container/Action2Cost
@onready var cycles_remaining:HBoxContainer = $InterfaceLayer/ScoresContainer/CyclesRemaining
@onready var path_prototype:TextureRect = $InterfaceLayer/ScoresContainer/CyclesRemaining/Path
@onready var level_over_container:Container = $InterfaceLayer/LevelOver
@onready var failure_label:Label = $InterfaceLayer/LevelOver/FailureLabel
@onready var success_label:Label = $InterfaceLayer/LevelOver/SuccessLabel
@onready var continue_button:Button = $InterfaceLayer/LevelOver/HBoxContainer/ContinueButton
@onready var restart_button:Button = $InterfaceLayer/LevelOver/HBoxContainer/RestartButton
@onready var quit_button:Button = $InterfaceLayer/LevelOver/HBoxContainer/QuitButton

signal on_mid_blink

func update_action_points(cur_points: int, max_points: int):
	action_points_label.text = str(cur_points, "/", max_points)
	return
	
func update_oxygen(cur_oxygen: float) -> void:
	oxygen_value_label.text = "%.2f%%" % cur_oxygen
	
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

func update_cycle_counts(current_cycle: int, total_cycles: int) -> void:
	var num_paths = cycles_remaining.get_child_count() - 3
	var needed_paths = total_cycles - current_cycle - 1
	if num_paths < needed_paths:
		for i in range(needed_paths - num_paths):
			var new_path : TextureRect = path_prototype.duplicate()
			cycles_remaining.add_child(new_path)
			cycles_remaining.move_child(new_path, cycles_remaining.get_child_count() - 2)
			new_path.visible = true
		
	elif num_paths > needed_paths:
		for i in range(num_paths - needed_paths):
			var path = cycles_remaining.get_child(cycles_remaining.get_child_count() - 2)
			if path != null:
				cycles_remaining.remove_child(path)
				path.queue_free()

func show_level_over(success : bool) -> void:
	level_over_container.visible = true
	failure_label.visible = !success
	success_label.visible = success
	continue_button.visible = success
	
func hide_level_over() -> void:
	level_over_container.visible = false

func play_fade_animation():
	if !animation_player.is_playing():
		animation_player.play("blink")
		
func _emit_mid_blink():
	emit_signal("on_mid_blink")
