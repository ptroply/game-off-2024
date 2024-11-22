extends Node2D

var day = 0
var tbox
var InfoBookSystem = load("res://Utility/InfoBookSystem/info_book_system.tscn")
var InventoryMenu = load("res://Utility/ItemMenu/inventory.tscn")
@onready var item_dict : Dictionary = get_node("/root/DataManager").read_json("res://items.json")

var items : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in item_dict.keys():
		items.get_or_add(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_inventory"):
		if items.values().has(true):
			var im = InventoryMenu.instantiate()
			im.start(items, item_dict)
			add_child(im)


func _on_field_map_ibs() -> void:
	var ibs = InfoBookSystem.instantiate()
	add_child(ibs)
	ibs.tree_exited.connect(_on_ibs_closed)
	get_tree().paused = true

func _on_ibs_closed():
	$FieldMap.delete_dbox()
	#get_tree().paused = false

func _on_field_map_try_add_inventory(context_flag: String) -> void:
	if context_flag in items.keys():
		items[context_flag] = true
		print(str("got item: ", context_flag, " ", items.get(context_flag)))
