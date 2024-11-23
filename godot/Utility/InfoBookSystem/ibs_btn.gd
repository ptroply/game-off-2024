extends Button

@onready var id : String
signal ibs_btn_up(btn_id : String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = text

func _on_button_up() -> void:
	ibs_btn_up.emit(id)
