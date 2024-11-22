extends Control

var info_dict : Dictionary
var InfoBox = load("res://Utility/ims/info_box.tscn")
var info_id_match : Array
signal get_info_ids(ids : Array)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ibs_json = get_node("/root/DataManager").read_json("res://Utility/InfoBookSystem/ibs.json")
	info_dict = ibs_json.database
	
	var buttons = $GridContainer.get_children()
	for btn in buttons:
		btn.ibs_btn_up.connect(_on_ibs_btn_up)
	$GridContainer.get_children().front().grab_focus()

func search_code_input():
	var case_id : String = $CodeBox.text
	print(str("searching ", case_id))
	var ibox = InfoBox.instantiate()
	add_child(ibox)
	if info_dict.has(case_id):
		print("FOUND")
		if !info_id_match.has(case_id):
			info_id_match.push_front(case_id)
		ibox.start(case_id, info_dict.get(case_id))
		ibox.tree_exited.connect(_on_ibox_closed)
		for c in $GridContainer.get_children():
			c.set_focus_mode(0)
	else:
		ibox.start("", ["CASE FILE NOT FOUND"])
		ibox.tree_exited.connect(_on_ibox_closed)
		for c in $GridContainer.get_children():
			c.set_focus_mode(0)


func _on_ibs_btn_up(btn_id : String):
	match btn_id.to_lower():
		"enter":
			if $CodeBox.text.length() != 4:
				print(str("Invalid entry: Must be 4 characters. Current: ", $CodeBox.text.length()))
				return
			else:
				search_code_input()
		"clear":
			$CodeBox.text = ""
		"exit":
			get_info_ids.emit(info_id_match)
			print(str("signal ", info_id_match))
			queue_free()
		_:
			if $CodeBox.text.length() < 4:
				$CodeBox.text += btn_id


	#if btn_id.matchn("enter"):
		#if $CodeBox.text.length() == 4:
			#var case_id : String = $CodeBox.text
			#print(str("searching ", case_id))
			#var ibox = info_box.instantiate()
			#add_child(ibox)
			#if info_dict.has(case_id):
				#print("FOUND")
				#if !info_id_match.has(case_id):
					#info_id_match.push_front(case_id)
				#ibox.start(case_id, info_dict.get(case_id))
				#ibox.tree_exited.connect(_on_ibox_closed)
				#for c in $GridContainer.get_children():
					#c.set_focus_mode(0)
			#else:
				#ibox.start("404", ["CASE FILE NOT FOUND"])
				#ibox.tree_exited.connect(_on_ibox_closed)
				#for c in $GridContainer.get_children():
					#c.set_focus_mode(0)
		#return
	#if btn_id.matchn("clear"):
		#$CodeBox.text = ""
		#return
	#if btn_id.matchn("exit"):
		#get_info_ids.emit(info_id_match)
		#print(str("signal ", info_id_match))
		#queue_free()
		#get_tree().paused = false
		#return

func _on_ibox_closed():
	for c in $GridContainer.get_children():
		c.set_focus_mode(2)
	$GridContainer/IbsBtnEnter.grab_focus()
	$CodeBox.text = ""
