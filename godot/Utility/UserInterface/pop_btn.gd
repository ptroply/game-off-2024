extends Button

@export var id : int
signal pop_btn_up(int)


func _on_button_up() -> void:
	pop_btn_up.emit(id)
