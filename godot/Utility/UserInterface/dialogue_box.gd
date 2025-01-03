extends Node2D

var style : StyleBoxFlat = preload("res://Utility/UserInterface/dialogue_style_box.tres")
var is_top_screen : bool
signal dialogue_flag(flag_key : String, flag_value : String)
var pop_text = load("res://Utility/UserInterface/pop_text.tscn")
var pop_up : bool
var portrait : Texture2D
@onready var label = $Label
var lock : bool
var context_dialogue : Array


func set_text(value : String):
	label.text = value

func start(target_position : Vector2, id : String, dialogues : Dictionary, contexts: Array) -> void:
	print(str("context stack: ", contexts))
	
	for i in range(contexts.size()):
		if contexts[i] in dialogues:
			context_dialogue += dialogues[contexts[i]]
	
	if context_dialogue.is_empty():
		context_dialogue = dialogues["default"]
		
	print(str(id, ": ", context_dialogue))
	
	for cd in context_dialogue:
		if typeof(cd) == TYPE_STRING:
			label.text += str(cd, "\n")
		else:
			if !contexts.has(cd.keys().front()):
				var pop = pop_text.instantiate()
				pop.start(cd)
				pop.flag_out.connect(_on_flag_out)
				add_child(pop)

	if target_position.y < 80:
		position.y = 112
	else: position.y = 0
	
	portrait = load(str("res://Sprites/Portraits/",id,".png"))
	
	set_portrait(portrait)
	
func set_portrait(portrait_texture: Texture2D):
	if portrait_texture == null:
		style.content_margin_left = 8
	else:
		style.content_margin_left = 44
	
	$Sprite2D.set_texture(portrait_texture)


func _on_flag_out(flag, context):
	pop_up = true
	set_text(context)
	dialogue_flag.emit(flag, context)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_accept") and !lock:
		if label.lines_skipped < label.get_line_count() - 3:
			label.lines_skipped += 3
		elif pop_up:
			pop_up = false
		else:
			queue_free()
