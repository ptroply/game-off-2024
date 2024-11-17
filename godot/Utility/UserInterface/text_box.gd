extends Node2D

var style : StyleBoxFlat = preload("res://Utility/UserInterface/dialogue_style_box.tres")
var is_top_screen : bool
@onready var label = $ColorRect/Label
signal dialogue_flag(String)
var pop_text = load("res://Utility/UserInterface/pop_text.tscn")
var pop_up : bool
var portrait : Texture2D
signal restart


func start(target_position : Vector2, id : String, dialogues : Dictionary, contexts: Array) -> void:
	print(str("context stack: ", contexts))
	var context_dialogue : Array
	
	##update to look at the context stack, not just the last one
	for i in range(contexts.size()):
		if contexts[i] in dialogues:
			context_dialogue = dialogues[contexts[i]]
			break
		#else: context_dialogue = dialogues["default"]
		
	print(str(id, ": ", context_dialogue))
	
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
	
	portrait = load(str("res://Sprites/Portraits/",id,".png"))
	
	set_portrait(portrait)
	
	get_tree().paused = true
	
func set_portrait(portrait_texture: Texture2D):
	if portrait_texture == null:
		style.content_margin_left = 8
	else:
		style.content_margin_left = 44
	
	$ColorRect/Sprite2D.set_texture(portrait_texture)


func _on_flag_out(flag, context):
	pop_up = true
	label.text = context
	dialogue_flag.emit(flag)
	
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
