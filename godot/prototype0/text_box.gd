extends Node2D

var style : StyleBoxFlat = preload("res://prototype0/dialogue_style_box.tres")
var is_top_screen : bool
@onready var line_count = $ColorRect/Label.get_line_count()

func start(target_position : Vector2, portrait : CompressedTexture2D = null) -> void:
	if target_position.y < 80:
		position.y = 112
	else: position.y = 0
	if portrait == null:
		style.content_margin_left = -1
	else:
		style.content_margin_left = 44
		$ColorRect/Sprite2D.set_texture(portrait)
	
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		if $ColorRect/Label.lines_skipped < line_count - 3:
			$ColorRect/Label.lines_skipped += 3
		elif $ColorRect/Label.lines_skipped + line_count:
			get_tree().paused = false
			queue_free()
