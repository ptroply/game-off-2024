extends Node2D

var context : Array = ["coffee"]

var tilemap : Array = [["breakroom","jail",0],
["offices","lobby",0],
[0,0,0]]

var tile_index : Array = [0,0]

var DialogueBox = load("res://Utility/UserInterface/dialogue_box.tscn")
var dbox

signal ibs
signal try_add_inventory(context_flag : String)

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
	dbox = DialogueBox.instantiate()
	add_child(dbox)
	dbox.dialogue_flag.connect(_on_dialogue_flag)
	dbox.tree_exited.connect(_on_dbox_closed)
	
	if context.is_empty():
		dbox.start(pos,id,dialogues,["default"])
	else:
		dbox.start(pos, id, dialogues, context)
	
	get_tree().paused = true

func _on_dbox_closed():
	get_tree().paused = false

func _on_dialogue_flag(flag_context) -> void:
	if flag_context == "enter code":
		dbox.lock = true
		ibs.emit()
	elif flag_context not in context:
		add_context_flag(flag_context)
		
func delete_dbox():
	dbox.queue_free()

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
	try_add_inventory.emit(new_context)
