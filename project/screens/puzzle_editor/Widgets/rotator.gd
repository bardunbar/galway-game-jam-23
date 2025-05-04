extends HBoxContainer
class_name Rotator

@export var label: String
@export var min_value: int = 0
@export var max_value: int = 1
@export var increment: int = 1
@onready var text_label: Label = $Label
@onready var value_label: Label = $Value

signal on_value_changed(new_value: int)

var cur_value: int = 0

func _ready() -> void:
	text_label.text = label
	cur_value = min_value
	value_label.text = str(cur_value)

func _on_prev_pressed() -> void:
	cur_value = clamp(cur_value - increment, min_value, max_value)
	value_label.text = str(cur_value)
	on_value_changed.emit(cur_value)

func _on_next_pressed() -> void:
	cur_value = clamp(cur_value + increment, min_value, max_value)
	value_label.text = str(cur_value)
	on_value_changed.emit(cur_value)

func set_value(new_value: int):
	cur_value = clamp(new_value, min_value, max_value)
	value_label.text = str(cur_value)
