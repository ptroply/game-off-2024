extends Control

var database_path = "res://Data/items.json"

var player_has : Dictionary
var all_items : Dictionary

var ItemBtn = load("res://Utility/ItemMenu/item.tscn")
var InfoBox = load("res://Utility/ItemMenu/info_box.tscn")



func start(player_items : Dictionary, items_dict : Dictionary):
	player_has = player_items
	all_items = items_dict

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	get_tree().paused = true
	
	for id in player_has.keys():
		if player_has.get(id) == true:
			var menu_item = ItemBtn.instantiate()
			var item_texture = load(str("res://Sprites/Items/", id, ".png"))
			menu_item.start(id, item_texture)
			menu_item.btn_select.connect(_on_btn_select)
			menu_item.btn_focus.connect(_on_btn_focus)
			$HBoxContainer.add_child(menu_item)
	
	$HBoxContainer.set_size(Vector2.ZERO)
	var first = $HBoxContainer.get_children().front()
	
	var item_info_box = InfoBox.instantiate()
	add_child(item_info_box)
	item_info_box.set_text(first.flag_id)
	first.grab_focus()

func _process(_delta):
	if Input.is_action_just_released("ui_cancel"):
		
		get_tree().paused = false
		queue_free()

## when the item is selected, display description text
func _on_btn_select(flag_id : String):
	var item_info_box = await InfoBox.instantiate()
	add_child(item_info_box)

	var desc_text = all_items.get(flag_id)
	print(str(flag_id, ": ", desc_text))
	item_info_box.set_text(desc_text)

## when the item is in focus, display the item name
func _on_btn_focus(flag_id : String):
	var item_name = get_node("InfoBox")
	if item_name == null:
		pass
	else: item_name.set_text(flag_id.to_upper())
