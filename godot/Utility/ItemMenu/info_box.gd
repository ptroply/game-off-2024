extends Node2D

var style : StyleBoxFlat = preload("res://Utility/UserInterface/info_style_box.tres")
@onready var label = $Label

func set_text(value : String):
	label.text = value

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if label.lines_skipped < label.get_line_count() - 3:
			label.lines_skipped += 3
		else:
			queue_free()

func start(id : String, details: Array) -> void:
	print(str(id, ": ", details))
	position.y = 112
	for cd in details:
		label.text += str(cd, "\n")
