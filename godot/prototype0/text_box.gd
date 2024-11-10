extends Node2D

var style : StyleBoxFlat = preload("res://prototype0/dialogue_style_box.tres")
var is_top_screen : bool
@onready var label = $ColorRect/Label


func start(target_position : Vector2, id : String, dialogue : Dictionary) -> void:
	
	label.text = dialogue.default
	
	if target_position.y < 80:
		position.y = 112
	else: position.y = 0
	var portrait = load(str("res://Utility/Portraits/",id,".png"))
	if portrait == null:
		style.content_margin_left = -1
	else:
		style.content_margin_left = 44
		$ColorRect/Sprite2D.set_texture(portrait)
	
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		if label.lines_skipped < label.get_line_count() - 3:
			label.lines_skipped += 3
		elif label.lines_skipped + label.get_line_count():
			get_tree().paused = false
			queue_free()
