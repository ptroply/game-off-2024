extends CharacterBody2D

var input_direction : Vector2
@onready var sprite = $CharacterSprite
@export var speed = 40
var walk_state = "idle"
var flip : bool
var tile_index : Array = [0,0]
signal update_map(index : Array)

func _physics_process(delta):
		input_direction = Vector2.ZERO
		
		if Input.is_action_pressed("ui_up"):
			walk_state = "walk_up"
			input_direction.y -= 1
		if Input.is_action_pressed("ui_down"):
			walk_state = "walk_down"
			input_direction.y += 1
		if Input.is_action_pressed("ui_left"):
			flip = false
			walk_state = "walk_side"
			input_direction.x -= 1
		if Input.is_action_pressed("ui_right"):
			flip = true
			walk_state = "walk_side"
			input_direction.x += 1
			
		input_direction = input_direction.normalized()
		
		if input_direction == Vector2.ZERO:
			walk_state = "idle"
		else:
			sprite.flip_h = flip
			move_and_collide(input_direction * speed * delta)
			
		animate_state()
		
		var p = position
		if p.x > 230:
			position.x = 20
			tile_index[1] += 1
		elif p.x < 20:
			position.x = 230
			tile_index[1] -= 1
		if p.y > 140:
			position.y = 20
			tile_index[0] += 1
		elif p.y < 20:
			position.y = 140
			tile_index[0] -= 1
			
		if position != p:
			update_map.emit(tile_index)


func animate_state():
	sprite.play(walk_state)

