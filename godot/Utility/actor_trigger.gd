extends Area2D

@export var id : String
signal trigger_entered(event_id : String, trigger_position : Vector2)
@onready var sprite_filepath = str("res://Sprites/SpriteFrames/", id,"_sprite_frames.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if FileAccess.file_exists(sprite_filepath):
	$CharacterSprite.sprite_frames = load(sprite_filepath)
	#else: set some error sprite
	$CharacterSprite.play("default")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		trigger_entered.emit(id, position)
