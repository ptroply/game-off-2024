extends CharacterBody2D

## Field Map Navigation
signal update_map(index : Array)
var tile_index : Array = [0,0]

## Character Movement and Animation
@export var speed = 40
var input_direction : Vector2
var walk_state = "idle"
var flip : bool


func _physics_process(delta):
	var input_dir = Vector2.ZERO
	
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
		$CharacterSprite.flip_h = flip
		move_and_collide(input_direction * speed * delta)
		
	animate_state()
	check_tilemap()
		
func check_tilemap() -> void:
	var current : Array = tile_index
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


func get_input() -> Vector2:
	var input_dir = Vector2.ZERO
	
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
	
	return input_dir

func animate_state():
	$CharacterSprite.play(walk_state)
