extends Resource
class_name Item

@export var name: String
@export var description: String
@export var count: int = 1
@export var icon: Texture
@export var rarity: String = "Common"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
