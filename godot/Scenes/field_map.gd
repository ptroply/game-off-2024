extends Node2D

var StartScreen : PackedScene = load("res://Scenes/start_screen.tscn")

var context : Array = []

var tilemap : Array = [["breakroom","jail","wire1"],
["offices","lobby","hotel_room"]]

var tile_index : Array = [0,0]

var field_dialogues : Dictionary
var DialogueBox = load("res://Utility/UserInterface/dialogue_box.tscn")
var dbox

signal ibs
signal try_add_inventory(context_flag : String)

func _ready() -> void:
	field_dialogues = get_node("/root/DataManager").read_json(str("res://Data/field_dialogues.json"))
	print(tilemap[tile_index[0]][tile_index[1]])
	load_tile(tilemap[tile_index[0]][tile_index[1]])
	
func load_tile(tile_code : String):
	var path = str("res://Scenes/", tile_code,".tscn")
	var new_map = load(path)
	$Label.text = tile_code.capitalize()
	if new_map == null:
		return
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
	
	var tcode : String
	
	if tile_index[0] > tilemap.size() - 1 or tile_index[0] < 0:
		$Player.darken()
		update("")
		return
	
	var tile_row : Array = tilemap[tile_index[0]]	
	
	if tile_index[1] > tile_row.size() -1 or tile_index[1] < 0 :
		$Player.darken()
		update("")
		return
	
	update(tile_row[tile_index[1]])
	
func add_context_flag(new_context : String):
	context.push_front(new_context)
	print(str("Context Stack Updated: ", context))
	
	if new_context.begins_with("take "):
		try_add_inventory.emit(new_context.erase(0,5))

func remove_from_field(item_id : String):
	var tile : TileMapLayer = get_child(2)
	#for tilemap : TileMapLayer in get_children():
	for actor in tile.get_children():
		if actor.id == item_id:
			actor.visible = false


func _on_player_game_over() -> void:
	dbox = DialogueBox.instantiate()
	add_child(dbox)
	dbox.tree_exited.connect(_on_gameover_dbox_closed)
	dbox.start($Player.position, "gameover", {"default" : ["Straying too far, you are lost in this place. You can't find the killer, and it would appear you've become their next victim..."]}, context)
	get_tree().paused = true

func _on_gameover_dbox_closed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(StartScreen)
