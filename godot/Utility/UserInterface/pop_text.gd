extends Control

var context : Dictionary

signal flag_out(flag: String, content: String)
@onready var box = $BoxContainer

func start(context_dict : Dictionary):
	context = context_dict


func _on_pop_btn_up(value : int):
	print(str(context.keys()[value], context.get(context.keys()[value])))
	flag_out.emit(context.keys()[value], context.get(context.keys()[value]))
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(str(context))
	for i in range(context.size()):
		var pop_btn = load("res://Utility/UserInterface/pop_btn.tscn")
		var pb = pop_btn.instantiate()
		pb.text = context.keys()[i].to_upper()
		pb.id = i
		pb.pop_btn_up.connect(_on_pop_btn_up)
		box.add_child(pb)
		
	#box.separation = 8
	box.set_size(Vector2.ZERO)
	box.get_children().front().grab_focus()
