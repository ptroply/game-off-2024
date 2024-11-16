extends Control

var context : Dictionary
var pop_btn = load("res://prototype0/pop_btn.tscn")
signal flag_out(flag: String, content: String)
@onready var hbox = $HBoxContainer

func start(context_dict : Dictionary):
	context = context_dict

func _on_pop_btn_up(value : int):
	flag_out.emit(context.keys()[value], context.get(context.keys()[value]))
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(str(context))
	for i in range(context.size()):
		var btn = pop_btn.instantiate()
		btn.text = context.keys()[i].to_upper()
		btn.id = i
		hbox.add_child(btn)
		btn.pop_btn_up.connect(_on_pop_btn_up)

	hbox.get_children().front().grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
