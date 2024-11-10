extends Node2D

var day = 0
var tilemap : Array = [["breakroom","jail",0],
["offices","lobby",0],
[0,0,0]]

var tile_index : Array = [0,0]

var text_box = load("res://prototype0/text_box.tscn")

func read_json(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	var finish = JSON.parse_string(content)
	return finish


#func start(tiles : Array):
	#tilemap = tiles
	#for i in range(tilemap.size()):
		#for n in range(tilemap[i].size()):
			#if tilemap[i][n].begins_with("start_"):
				#tile_index = [i, n]

func _ready() -> void:
	load_tile(tilemap[tile_index[0]][tile_index[1]])
	
func load_tile(tile_code : String):
	var path = str("res://prototype0/", tile_code,".tscn")
	var new_map = load(path)
	print(str(tile_code, " map loaded"))
	var n = new_map.instantiate()
	add_child(n)
	
	for t : Area2D in n.get_children():
		print(str(t.name, " loaded, ID: ", t.id))
		t.trigger_entered.connect(_on_trigger_entered)

func _on_trigger_entered(id : String, pos : Vector2):
	var dialogues = read_json(str("res://Utility/Dialogues/", id, ".json"))
	print(str(id, " triggered at ", pos))
	var t = text_box.instantiate()
	add_child(t)
	
	await t.start(pos, id, dialogues[day])

func update(tile_code : String):
	for n in get_children():
		remove_child(n)
		n.queue_free()
	load_tile(tile_code)


func _on_player_update_map(index: Array) -> void:
	tile_index = index
	print(str("map index ", tile_index))
	var tile_row = tilemap[tile_index[0]]
	update(tile_row[tile_index[1]])
