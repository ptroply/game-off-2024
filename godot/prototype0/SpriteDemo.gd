extends Node2D

var text_box = load("res://prototype0/text_box.tscn")
var npc_sprite = load("res://prototype0/deputy-gary-portrait.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_deputy_gary_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var t = text_box.instantiate()
		add_child(t)
		
		await t.start($Player.position, npc_sprite)
		
		print(body.name)
	
