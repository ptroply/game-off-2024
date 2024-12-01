extends Node2D

var StartScreen : PackedScene = load("res://Scenes/start_screen.tscn")

var context : Array = []

var tilemap : Array = [
	["voidm10","voidm11","",""],
	["void00","","",""],
	["chiefs_office","breakroom","jail","void13"],
	["","offices","lobby","hotel_room"]]


var field_dialogues : Dictionary
var DialogueBox = load("res://Utility/UserInterface/dialogue_box.tscn")
var dbox


signal ibs
signal try_add_inventory(context_flag : String)

var void_index = 0

func _ready() -> void:
	var tile_x : int
	var tile_y : int
	for row : Array in tilemap:
		if row.has("lobby"):
			tile_x = row.find("lobby")
			tile_y = tilemap.find(row)
	$Player.tile_index = [tile_y, tile_x]
	
	$NoiseAnimation.play(str(void_index))
	field_dialogues = get_node("/root/DataManager").read_json(str("res://Data/field_dialogues.json"))
	print(tilemap[$Player.tile_index[0]][$Player.tile_index[1]])
	load_tile(tilemap[$Player.tile_index[0]][$Player.tile_index[1]])
	
func load_tile(tile_code : String):
	var path = str("res://Scenes/", tile_code,".tscn")
	var new_map = load(path)
	$Footer/Label.text = tile_code.capitalize()
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
	$Player.tile_index = index
	print(str("map index ", $Player.tile_index))
	
	var tcode : String
	
	if $Player.tile_index[0] > tilemap.size() - 1 or $Player.tile_index[0] < 0:
		player_stray(true)
		update("")
		print("Player stray X axis")
		return
	
	var tile_row : Array = tilemap[$Player.tile_index[0]]	
	
	if $Player.tile_index[1] > tile_row.size() -1 or $Player.tile_index[1] < 0 :
		player_stray(true)
		update("")
		print("Player stray Y axis")
		return
	
	tcode = tile_row[$Player.tile_index[1]]
	if tcode.begins_with("void"):
		player_stray(true)
	else:
		player_stray(false)

	update(tile_row[$Player.tile_index[1]])
	
func player_stray(dir: bool):
	if dir:
		$Player.darken()
		void_index += 1
	else:
		$Player.lighten()
		if void_index > 0:
			void_index -= 1
	$NoiseAnimation.play(str(void_index))
	
func add_context_flag(new_context : String):
	context.push_front(new_context)
	print(str("Context Stack Updated: ", context))
	
	if new_context.begins_with("take "):
		try_add_inventory.emit(new_context.erase(0,5))

func remove_from_field(item_id : String):
	var tile : TileMapLayer
	for n in get_children():
		if n is TileMapLayer:
			tile = n
	#for tilemap : TileMapLayer in get_children():
	for actor in tile.get_children():
		if actor.id == item_id:
			actor.queue_free()


func _on_player_game_over() -> void:
	dbox = DialogueBox.instantiate()
	add_child(dbox)
	dbox.tree_exited.connect(_on_gameover_dbox_closed)
	dbox.start($Player.position, "gameover", field_dialogues["gameover"], context)
	get_tree().paused = true

func _on_gameover_dbox_closed():
	get_tree().paused = false
	DataManager.credits_flag = true
	get_tree().change_scene_to_packed(StartScreen)
