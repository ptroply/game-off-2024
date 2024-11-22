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
		#else:
			#var pop = pop_text.instantiate()
			#pop.start(cd)
			#pop.flag_out.connect(_on_flag_out)
			#add_child(pop)

	#if target_position.y < 80:
		#position.y = 112
	#else: position.y = 0
	
	#portrait = load(str("res://Sprites/Portraits/",id,".png"))
	#
	#set_portrait(portrait)
	
	#get_tree().paused = true
	
#func set_portrait(portrait_texture: Texture2D):
	#if portrait_texture == null:
		#style.content_margin_left = 8
	#else:
		#style.content_margin_left = 44
	#
	#$Sprite2D.set_texture(portrait_texture)


#func _on_flag_out(flag, context):
	#pop_up = true
	#set_text(context)
	#dialogue_flag.emit(flag)
