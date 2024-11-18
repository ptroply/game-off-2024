extends Node2D

var style : StyleBoxFlat = preload("res://Utility/UserInterface/dialogue_style_box.tres")
@onready var label = $Label

func set_text(value : String):
	label.text = value
	style.content_margin_left = 8

func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		if label.lines_skipped < label.get_line_count() - 3:
			label.lines_skipped += 3
