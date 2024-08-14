class_name ButtonManager
extends Node

@export var button_manager : Control
@export var resource_manager : ResourceManager
@export var notif : PackedScene
@export var button_timer : Timer
@export var bonus_manager : Node2D
@export var loaded_buttons : Node2D
var buttons : Dictionary
var resources : Dictionary
var bonuses : Dictionary
var button_pos : Dictionary

func _ready():
	await owner.ready
	EventBus.connect("activate_button", _send_bonuses)
	resources = resource_manager.resources
	bonuses = bonus_manager.bonuses
	_import_button_data("res://data/button_data.txt")
	_create_buttons()
	_add_button_data()
	for button in loaded_buttons.get_children():
		_update_bonuses(button)


func _physics_process(delta):
	for button in loaded_buttons.get_children():
		_unlock_buttons(button)
		buttons[button.name].update_text()
		_update_button_active(button)


func _on_button_hovered(button):
	for node in button.get_children():
		if node.name == "Notification":
			node.queue_free()


func _on_button_pressed(event, button):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				_left_click(button)
			MOUSE_BUTTON_RIGHT:
				_right_click(button)


func _left_click(button):
	if buttons[button.name].add_resource != null:
		buttons[button.name]._on_activate("click")
	else:
		buttons[button.name]._on_activate("click")


func _toggle_all():
	if buttons["ResourceTime"].unpause_timer:
		button_timer.start()
	if !buttons["ResourceTime"].unpause_timer:
		button_timer.stop()
	for button in loaded_buttons.get_children():
		buttons[button.name].unpause_timer = buttons["ResourceTime"].unpause_timer


func _right_click(button):
	if buttons[button.name].on_timer_active:
		if buttons[button.name].unpause_timer:
			buttons[button.name].unpause_timer = false
		else:
			buttons[button.name].unpause_timer = true
			buttons["ResourceTime"].unpause_timer = true
			button_timer.start()
	if buttons[button.name].add_resource != null:
		if buttons[button.name].add_resource.name == "Time":
			_toggle_all()


func _import_button_data(file_name):
	var file = FileAccess.open(file_name, FileAccess.READ)
	var dict_name = ""
	while !file.eof_reached():
		var line = file.get_line()
		if line != "":
			var words = line.split("==")
			if words[0] == "dict_name":
				dict_name = words[1]
				buttons[dict_name] = ButtonData.new()
			elif words[0] == "main_text":
				buttons[dict_name].main_text = words[1]
			elif words[0] == "is_unlocked":
				if words[1] == "false":
					buttons[dict_name].is_unlocked = false
				else:
					buttons[dict_name].is_unlocked = true
			elif words[0] == "cost":
				buttons[dict_name].cost[resources[words[1]]] = int(words[2])
			elif words[0] == "unlock_criteria":
				buttons[dict_name].unlock_criteria[resources[words[1]]] = int(words[2])
			elif words[0] == "cost_scaling":
				buttons[dict_name].cost_scaling = float(words[1])
			elif words[0] == "on_timer_active":
				if words[1] == "false":
					buttons[dict_name].on_timer_active = false
				else:
					buttons[dict_name].on_timer_active = true
			elif words[0] == "unpause_timer":
				if words[1] == "false":
					buttons[dict_name].unpause_timer = false
				else:
					buttons[dict_name].unpause_timer = true
			elif words[0] == "per_second":
				buttons[dict_name].per_second = int(words[1])
			elif words[0] == "per_click":
				buttons[dict_name].per_click = int(words[1])
			elif words[0] == "add_resource":
				buttons[dict_name].add_resource = resources[words[1]]
			elif words[0] == "add_random_resources":
				buttons[dict_name].add_random_resources[resources[words[1]]] = [int(words[2]),int(words[3]),int(words[4])]
			elif words[0] == "random_resource_efficiency":
				buttons[dict_name].random_resource_efficiency = int(words[1])
			elif words[0] == "location":
				buttons[dict_name].location = words[1]
			elif words[0] == "perma_unlocked":
				if words[1] == "false":
					buttons[dict_name].perma_unlocked = false
				else:
					buttons[dict_name].perma_unlocked = true
			elif words[0] == "bonus":
				if words[2] == "self":
					_apply_bonuses(dict_name, bonuses[words[1]], buttons[dict_name])
				else:
					_apply_bonuses(dict_name, bonuses[words[1]], buttons[words[2]])
			elif words[0] == "pos":
				button_pos[dict_name] = Vector2(int(words[1]), int(words[2]))
	file.close()


func _send_bonuses(button):
	for reciever in buttons[button.name].out_bonus:
		_update_bonuses(reciever.button)


func _apply_bonuses(sender : String, bonus : BonusData, reciever : ButtonData):
	if !reciever.in_bonus.has(sender):
		reciever.in_bonus[sender] = []
	reciever.in_bonus[sender].append(bonus)
	buttons[sender].out_bonus.append(reciever)


func _update_bonuses(button : Button):
	var quantity = 1
	buttons[button.name].per_click = 0
	buttons[button.name].per_second = 0
	for sender in buttons[button.name].in_bonus:
		if buttons[sender].add_resource != null:
			if sender != button.name:
				quantity = buttons[sender].add_resource.quantity
		for bonus in buttons[button.name].in_bonus[sender]:
			buttons[button.name].per_click += bonus.per_click * quantity
			buttons[button.name].per_second += bonus.per_second * quantity


func _add_button_data():
	for button in loaded_buttons.get_children():
		button.connect("gui_input",_on_button_pressed.bind(button))
		button.connect("mouse_entered",_on_button_hovered.bind(button))
		buttons[button.name].button = button
		if !buttons[button.name].is_unlocked:
			button.visible = false
		button.connect("visibility_changed",_on_visibility_changed.bind(buttons[button.name].location))


func _add_notif(button : Button):
	var notif_icon = notif.instantiate()
	notif_icon.visible = true
	button.add_child(notif_icon)


func _unlock_buttons(button : Button):
	if buttons[button.name].is_unlocked:
		return
	if !buttons[button.name].perma_unlocked:
		return
	var unlock = true
	for resource in buttons[button.name].unlock_criteria:
		if resource.quantity <= buttons[button.name].unlock_criteria[resource]:
			unlock = false
			break
	if unlock:
		buttons[button.name].is_unlocked = true
		button.visible = true
		_add_notif(button)
		EventBus.emit_signal("unlock_button", button)


func _on_resource_timer_timeout():
	Player.total_seconds += 1
	for button in loaded_buttons.get_children():
		if buttons[button.name].add_resource != null:
			if buttons[button.name].unpause_timer and buttons[button.name].on_timer_active:
				buttons[button.name]._on_activate("second")
		else:
			buttons[button.name]._on_activate("second")


func _update_button_active(button : Button):
	if buttons[button.name].add_resource != null:
		if buttons[button.name].per_second > 0:
			buttons[button.name].on_timer_active = true


func _create_buttons():
	for button in buttons:
		var template = preload("res://scenes/buttontemplate.tscn").instantiate()
		template.name = button
		loaded_buttons.add_child(template)
		template.position = button_pos[button]


func _on_visibility_changed(location):
	EventBus.emit_signal("vis_notif", location)
