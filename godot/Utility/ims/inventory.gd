extends Node

var items = {}

func add_item(item: Item) -> void:
	if items.has(item.name):
		items[item.name].count += item.count # Increase count of existing item
	else:
		items[item.name] = item.duplicate() # Store a copy of the item
	update_inventory_display() # Refresh UI

func remove_item(item_name: String, count: int = 1) -> void:
	if items.has(item_name) and items[item_name].count >= count:
		items[item_name].count -= count #Decrement count if multiple
		if items[item_name].count <= 0:
			items.erase(item_name) # Erase item if count is now zero
		update_inventory_display() # Refresh UI
	else:
		print("Not enough items to remove or item does not exist.") 

func update_inventory_display() -> void:
	var container = $Control/VBoxContainer
	container.clear() # Clear UI for a reset
	
	for item in items.values(): # Loop through inventory
		var label = Label.new() # Create new label for each item
		# The following uses template placeholders where %s, %d, and Rarity: %s 
		# will be replaced by item.name, item.count and item.rarity respectively
		label.txt = "%s: %d (Rarity: %s)" % [item.name, item.count, item.rarity]
		container.add_child(label) # Attach properties and add to parent

		# The following properties are handled separately 
		# so that they may be optional
		if item.description != "":
			var desc_label = Label.new() 
			desc_label.text = item.description
			container.add_child(desc_label)

		if item.icon != null:
			var icon = TextureRect.new()
			icon.texture = item.icon
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			container.add_child(icon)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
