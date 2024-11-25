extends Node2D

var scroll_timer
var scroll : bool

var flash_timer
var flash : bool

@onready var prelude = DataManager.read_json("res://Data/prelude.json")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if DataManager.credits_flag == false:
		$TitleScroll/Prelude.text = prelude["default"]
		$TitleScroll/Prelude.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		$TitleScroll/Highlight.visible = true
	else:
		$TitleScroll/Prelude.text = prelude["credits"]
		$TitleScroll/Prelude.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		$TitleScroll/Highlight.visible = false
	
	MusicBox.set_music("red_walker")
	flash_timer = Timer.new()
	add_child(flash_timer)
	flash_timer.wait_time = .6
	flash_timer.timeout.connect(_on_flash_timer_timeout)
	flash_timer.start()
	scroll_timer = Timer.new()
	add_child(scroll_timer)
	scroll_timer.wait_time = 3.0
	scroll_timer.timeout.connect(_on_scroll_timer_timeout)
	scroll_timer.start()
	
func _on_flash_timer_timeout():
	if flash == true:
		flash = false
	elif flash == false:
		flash = true
	
	flash_timer.wait_time = 1
	flash_timer.start()

	
func _on_scroll_timer_timeout():
	scroll = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flash == false:
		$TitleScroll/PressStart.set("theme_override_colors/font_color", Color.WHITE)
	else:
		$TitleScroll/PressStart.set("theme_override_colors/font_color", Color.BLACK)

		
	#print($TitleScroll/PressStart.font_color)
	if Input.is_action_just_released("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/game_base.tscn")
		
	if $TitleScroll/Title2.global_position.y < -9:
		$TitleScroll.set_position(Vector2(0,-8))
		scroll = false
		scroll_timer.wait_time = 4
		scroll_timer.start()
		MusicBox.play()
		$TitleScroll/Prelude.text = prelude["default"]
		$TitleScroll/Prelude.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		$TitleScroll/Highlight.visible = true

	if scroll:
		$TitleScroll.move_local_y(-0.167, true)
	
