extends Node2D

var style : StyleBoxFlat = preload("res://prototype0/dialogue_style_box.tres")
var is_top_screen : bool
@onready var label = $ColorRect/Label
signal dialogue_flag(context)
var pop_text = load("res://prototype0/pop_text.tscn")
var pop_up : bool


func start(target_position : Vector2, id : String, dialogues, context: String = "default") -> void:
	
	var context_dialogue = dialogues[context]
	print(str("full context: ", context_dialogue))
	
	for cd in context_dialogue:
		if typeof(cd) == TYPE_STRING:
			label.text += str(cd, "\n")
		else:
			var pop = pop_text.instantiate()
			pop.start(cd)
			pop.flag_out.connect(_on_flag_out)

			add_child(pop)
			

	if target_position.y < 80:
		position.y = 112
	else: position.y = 0
	var portrait = load(str("res://Utility/Portraits/",id,".png"))
	if portrait == null:
		style.content_margin_left = 8
	else:
		style.content_margin_left = 44
		$ColorRect/Sprite2D.set_texture(portrait)
	
	get_tree().paused = true

func _on_flag_out(flag, context):
	pop_up = true
	print(str("flag out: ", flag, context))
	label.text = context
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		if label.lines_skipped < label.get_line_count() - 3:
			label.lines_skipped += 3
		elif pop_up:
			pop_up = false
		else:
			get_tree().paused = false
			queue_free()
