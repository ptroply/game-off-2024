extends Node2D

var text_box = load("res://prototype0/text_box.tscn")
var npc_sprite = load("res://prototype0/deputy-gary-portrait.png")




var tile_index : Array = [0,0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if Input.is_action_just_released("ui_cancel"):
		#get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	
	get_node("Player").position
	var p = $Player.position
	$Label.text = str("X:", int(p.x), " Y:", int(p.y))
	
	#if p.x > 230:
		#$Player.position.x = 20
		#tile_index[1] += 1
	#elif p.x < 20:
		#$Player.position.x = 230
		#tile_index[1] -= 1
	#if p.y > 140:
		#$Player.position.y = 20
		#tile_index[0] += 1
	#elif p.y < 20:
		#$Player.position.y = 140
		#tile_index[0] -= 1
	
	#var tile_row = tilemap[tile_index[0]]
	#$FieldMap.update(tile_row[tile_index[1]])


func _on_deputy_gary_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var t = text_box.instantiate()
		add_child(t)
		
		await t.start($Player.position, npc_sprite)
		
		print(body.name)
	
