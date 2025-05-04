extends Node2D

@export var game_scene: PackedScene
@export var puzzle_editor_scene: PackedScene
@export var skip_to_game: bool = false

@onready var play_button: Button = $MenuUI/CenterContainer/UIContainer/ControlContainer/PlayButton
@onready var editor_button: Button = $MenuUI/CenterContainer/UIContainer/ControlContainer/PuzzleEditor
@onready var quit_button: Button = $MenuUI/CenterContainer/UIContainer/ControlContainer/QuitButton

func _ready() -> void:
	play_button.grab_focus()
	play_button.pressed.connect(_on_play_button_pressed)
	editor_button.pressed.connect(_on_editor_button_pressed)
	quit_button.visible = not OS.has_feature("web")
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	if skip_to_game:
		get_tree().change_scene_to_packed(game_scene)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
		
func _on_editor_button_pressed() -> void:
	get_tree().change_scene_to_packed(puzzle_editor_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
