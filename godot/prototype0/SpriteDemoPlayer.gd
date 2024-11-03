extends CharacterBody2D

var input_direction : Vector2

var walk_state = "default"
var flip : bool

func _physics_process(delta):
		var speed = 30
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
			walk_state = "default"
		else:
			$AnimatedSprite2D.flip_h = flip
			move_and_collide(input_direction * speed * delta)
			
		animate_state()


func animate_state():
	$AnimatedSprite2D.play(walk_state)
