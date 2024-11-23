extends Node2D

var context : Array = []

var tilemap : Array = [["breakroom","jail",0],
["offices","lobby","hotel_room"],
[0,0,0]]

var tile_index : Array = [0,0]

var field_dialogues : Dictionary
var DialogueBox = load("res://Utility/UserInterface/dialogue_box.tscn")
var dbox

signal ibs
signal try_add_inventory(context_flag : String)

func _ready() -> void:
	field_dialogues = get_node("/root/DataManager").read_json(str("res://Data/field_dialogues.json"))
	load_tile(tilemap[tile_index[0]][tile_index[1]])
	
func load_tile(tile_code : String):
	var path = str("res://Scenes/", tile_code,".tscn")
	var new_map = load(path)
	$Label.text = tile_code.capitalize()
	var n = new_map.instantiate()
	add_child(n)
	
	for trig : Area2D in n.get_children():
		print(str(trig.name, " loaded, ID: ", trig.id))
		trig.trigger_entered.connect(_on_trigger_entered)
		for c : String in context:
			if c.begins_with("take "):
				remove_from_field(c.erase(0,5))

func _on_trigger_entered(id : String, pos : Vector2):
	var trigger_dialogue = field_dialogues.get(id)
	print(str(id, " triggered at ", pos))
	dbox = DialogueBox.instantiate()
	add_child(dbox)
	dbox.dialogue_flag.connect(_on_dialogue_flag)
	dbox.tree_exited.connect(_on_dbox_closed)
	
	if context.is_empty():
		dbox.start(pos,id,trigger_dialogue,["default"])
	else:
		dbox.start(pos, id, trigger_dialogue, context)
	
	get_tree().paused = true

func _on_dbox_closed():
	get_tree().paused = false

func _on_dialogue_flag(flag_key : String, flag_value : String) -> void:
	if flag_key == "enter code":
		print("activating Info Book System")
		dbox.lock = true
		ibs.emit()
	elif flag_key not in context:
		add_context_flag(flag_key)
		
func delete_dbox():
	dbox.queue_free()

func update(tile_code : String):
	for n in get_children():
		if n is TileMapLayer:
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
	
	if new_context.begins_with("take "):
		try_add_inventory.emit(new_context.erase(0,5))

func remove_from_field(item_id : String):
	var tilemap : TileMapLayer = get_child(2)
	#for tilemap : TileMapLayer in get_children():
	for actor in tilemap.get_children():
		if actor.id == item_id:
			actor.visible = false
