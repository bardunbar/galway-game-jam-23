extends Node2D

@export var main_menu_scene: PackedScene
@export var intro_lines: Array[String]
@export var seconds_per_line: float = 2.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var intro_text_label: Label = $CanvasLayer/IntroTextLabel

var current_line = 0

func _ready() -> void:
	if intro_lines.is_empty():
		get_tree().change_scene_to_packed(main_menu_scene)
	else:
		intro_text_label.text = intro_lines[current_line]
		get_tree().create_timer(seconds_per_line).timeout.connect(_on_timeout)
		
func _on_timeout():
	if current_line < intro_lines.size():
		play_next_line()
	else:
		get_tree().change_scene_to_packed(main_menu_scene)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Action_1"):
		get_tree().change_scene_to_packed(main_menu_scene)

func _on_animation_finished(animation_name: String):
	get_tree().create_timer(seconds_per_line).timeout.connect(_on_timeout)

func on_mid_fade():
	if (current_line + 1 >= intro_lines.size()):
		get_tree().change_scene_to_packed(main_menu_scene)
		return 
		
	intro_text_label.text = intro_lines[current_line+1]
	current_line += 1
	
func play_next_line():
	animation_player.animation_finished.connect(_on_animation_finished)
	animation_player.play("fade_intro_text")
