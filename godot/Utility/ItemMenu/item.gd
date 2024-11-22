extends Button

#@export var name: String
#@export var description: String
#@export var count: int = 1
#@export var rarity: String = "Common"

var flag_id : String
signal btn_select(id : String)
signal btn_focus(id : String)

func start(id: String, texture : Texture):
	flag_id = id
	if texture != null:
		icon = texture
	else: icon = load("res://Sprites/Items/question.png")
	


func _on_button_up() -> void:
	btn_select.emit(flag_id)


func _on_focus_entered() -> void:
	btn_focus.emit(flag_id)
