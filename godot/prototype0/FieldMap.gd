extends Node2D

#var tilemap : Array
@onready var tilemap : Array = [["breakroom","jail",0],
["offices","lobby",0],
[0,0,0]]

var tile_index : Array = [0,0]

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
	var n = new_map.instantiate()
	add_child(n)
	
	for t : Area2D in n.get_children():
		print(str("LOADED ", t.name))
		t.trigger_entered.connect(_on_trigger_entered)

func _on_trigger_entered(id : int):
	print(str("ID# ", id, " triggered"))

func update(tile_code : String):
	for n in get_children():
		remove_child(n)
		n.queue_free()
	load_tile(tile_code)


func _on_player_update_map(index: Array) -> void:
	tile_index = index
	print(str("tile index = ", tile_index))
	var tile_row = tilemap[tile_index[0]]
	update(tile_row[tile_index[1]])
