extends Node2D

var day = 0
var context : Array = ["coffee"]
var tbox
var ItemBookSystem = load("res://Utility/InfoBookSystem/info_book_system.tscn")

var tilemap : Array = [["breakroom","jail",0],
["offices","lobby",0],
[0,0,0]]

var tile_index : Array = [0,0]

var text_box = load("res://Utility/UserInterface/dialogue_box.tscn")
var inventory_menu = load("res://Utility/ims/inventory.tscn")

#func read_json(file_path) -> Dictionary:
	#var file = FileAccess.open(file_path, FileAccess.READ)
	#var content = file.get_as_text()
	#var finish = JSON.parse_string(content)
	#return finish

#func start(tiles : Array):
	#tilemap = tiles
	#for i in range(tilemap.size()):
		#for n in range(tilemap[i].size()):
			#if tilemap[i][n].begins_with("start_"):
				#tile_index = [i, n]
				
func _process(_delta):
	if Input.is_action_just_released("ui_inventory"):
		var im = inventory_menu.instantiate()
		im.start(context)
		add_child(im)
	
	#if Input.is_action_just_released("ui_accept"):
		#if tbox != null:
			#if tbox.lines_skipped < tbox.get_line_count() - 3:
				#tbox.lines_skipped += 3
			#elif tbox.pop_up:
				#tbox.pop_up = false
			#else:
				#get_tree().paused = false
				#queue_free()


func _ready() -> void:
	load_tile(tilemap[tile_index[0]][tile_index[1]])
	
func load_tile(tile_code : String):
	var path = str("res://Scenes/", tile_code,".tscn")
	var new_map = load(path)
	print(str(tile_code, " map loaded"))
	var n = new_map.instantiate()
	add_child(n)
	
	for trig : Area2D in n.get_children():
		print(str(trig.name, " loaded, ID: ", trig.id))
		trig.trigger_entered.connect(_on_trigger_entered)

func _on_trigger_entered(id : String, pos : Vector2):
	var dialogues = get_node("/root/DataManager").read_json(str("res://Dialogues/", id, ".json"))
	print(str(id, " triggered at ", pos))
	tbox = text_box.instantiate()
	add_child(tbox)
	tbox.dialogue_flag.connect(_on_dialogue_flag)
	
	if context.is_empty():
		tbox.start(pos,id,dialogues,["default"])
	else:
		tbox.start(pos, id, dialogues, context)
	await tbox.tree_exited
	
func _on_dialogue_flag(flag_context) -> void:
	if flag_context == "enter code":
		var ibs = ItemBookSystem.instantiate()
		add_child(ibs)
	elif flag_context not in context:
		add_context_flag(flag_context)

func update(tile_code : String):
	for n in get_children():
		if n.name != "Player":
			remove_child(n)
			n.queue_free()
	load_tile(tile_code)


func _on_player_update_map(index: Array) -> void:
	tile_index = index
	print(str("map index ", tile_index))
	var tile_row = tilemap[tile_index[0]]
	update(tile_row[tile_index[1]])
	
func add_context_flag(new_context : String):

	context.push_front(new_context)
	print(str("Context Stack Updated: ", context))
