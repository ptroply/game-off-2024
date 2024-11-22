extends Control

var player_has : Dictionary
var all_items : Dictionary
var ItemBtn = load("res://Utility/ims/item.tscn")
var InfoBox = load("res://Utility/ims/info_box.tscn")
var item_info_box
var database_path = "res://items.json"


func start(player_items : Dictionary, items_dict : Dictionary):
	player_has = player_items
	all_items = items_dict

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	#item_dict = get_node("/root/DataManager").read_json("res://items.json")
	for id in player_has.keys():
		if player_has.get(id) == true:
			
		#if items.has(id):
			var menu_item = ItemBtn.instantiate()
			var item_texture = load(str("res://Sprites/Items/", id, ".png"))
			menu_item.start(id, item_texture)
			menu_item.btn_select.connect(_on_btn_select)
			menu_item.btn_focus.connect(_on_btn_focus)
			$HBoxContainer.add_child(menu_item)
	
	$HBoxContainer.set_size(Vector2.ZERO)
	var first = $HBoxContainer.get_children().front()
	
	item_info_box = InfoBox.instantiate()
	add_child(item_info_box)
	item_info_box.set_text(first.flag_id)
	first.grab_focus()

func _process(_delta):
	if Input.is_action_just_released("ui_inventory"):
		get_tree().paused = false
		queue_free()

## when the item is selected, display description text
func _on_btn_select(flag_id : String):
	#var item_info_box = await info_box.instantiate()
	#add_child(item_info_box)

	var desc_text = all_items.get(flag_id)
	print(str(flag_id, ": ", desc_text))
	item_info_box.set_text(desc_text)

## when the item is in focus, display the item name
func _on_btn_focus(flag_id : String):
	var item_name = get_node("InfoBox")
	if item_name == null:
		pass
	else: item_name.set_text(flag_id)

#func add_item(item: Item) -> void:
	#if items.has(item.name):
		#items[item.name].count += item.count # Increase count of existing item
	#else:
		#items[item.name] = item.duplicate() # Store a copy of the item
	#update_inventory_display() # Refresh UI
#
#func remove_item(item_name: String, count: int = 1) -> void:
	#if items.has(item_name) and items[item_name].count >= count:
		#items[item_name].count -= count #Decrement count if multiple
		#if items[item_name].count <= 0:
			#items.erase(item_name) # Erase item if count is now zero
		#update_inventory_display() # Refresh UI
	#else:
		#print("Not enough items to remove or item does not exist.") 
#
#func update_inventory_display() -> void:
	#var container = $Control/VBoxContainer
	#container.clear() # Clear UI for a reset
	#
	#for item in items.values(): # Loop through inventory
		#var label = Label.new() # Create new label for each item
		## The following uses template placeholders where %s, %d, and Rarity: %s 
		## will be replaced by item.name, item.count and item.rarity respectively
		#label.txt = "%s: %d (Rarity: %s)" % [item.name, item.count, item.rarity]
		#container.add_child(label) # Attach properties and add to parent
#
		## The following properties are handled separately 
		## so that they may be optional
		#if item.description != "":
			#var desc_label = Label.new() 
			#desc_label.text = item.description
			#container.add_child(desc_label)
#
		#if item.icon != null:
			#var icon = TextureRect.new()
			#icon.texture = item.icon
			#icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			#container.add_child(icon)
