extends Node2D

var text_box = load("res://prototype0/text_box.tscn")
var npc_sprite = load("res://prototype0/deputy-gary-portrait.png")




var tile_index : Array = [0,0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	##if Input.is_action_just_released("ui_cancel"):
		##get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	#
	#var p = $Player.position
	#$Label.text = str("X:", int(p.x), " Y:", int(p.y))


func _on_deputy_gary_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var t = text_box.instantiate()
		add_child(t)
		
		await t.start($Player.position, npc_sprite)
		
		print(body.name)
	
