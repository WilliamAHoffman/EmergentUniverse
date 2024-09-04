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
var button_children : Array

func _ready() -> void:
	await owner.ready
	EventBus.connect("activate_button", _send_bonuses)
	EventBus.connect("gain_resource", _is_affordable)
	resources = resource_manager.resources
	bonuses = bonus_manager.bonuses
	_import_button_data("res://data/base/button_data.txt")
	_import_button_data("res://data/saves/save_button.txt")
	_create_buttons()
	_get_child_buttons()
	_add_button_data()
	for button in button_children:
		_update_bonuses(button)
	_is_affordable(null)
	EventBus.emit_signal("finishbuttons", buttons)


func _physics_process(_delta) -> void:
	for button in button_children:
		_unlock_buttons(button)
		buttons[button.name].update_text()
		_update_button_active(button)


func _on_button_hovered(button) -> void:
	for node in button.get_children():
		if node.name == "Notification":
			node.queue_free()


func _on_button_pressed(event, button) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if Input.is_action_pressed("single"):
					_left_click(button, "single")
				else:
					_left_click(button, "click")
			MOUSE_BUTTON_RIGHT:
				_right_click(button)


func _left_click(button, type) -> void:
	buttons[button.name]._on_activate(type)


func _toggle_all() -> void:
	if buttons["ResourceTime"].unpause_timer:
		button_timer.start()
	if !buttons["ResourceTime"].unpause_timer:
		button_timer.stop()
	for button in loaded_buttons.get_children():
		buttons[button.name].unpause_timer = buttons["ResourceTime"].unpause_timer


func _right_click(button) -> void:
	if !_check_time():
		return
	
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


func _import_button_data(file_name) -> void:
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
			elif words[0] == "perma_unlocked":
				if words[1] == "false":
					buttons[dict_name].perma_unlocked = false
				else:
					buttons[dict_name].perma_unlocked = true
			elif words[0] == "bonus":
				_apply_bonuses(buttons[dict_name], bonuses[words[1]], buttons[words[2]])
			elif words[0] == "pos":
				buttons[dict_name].position = Vector2(int(words[1]), int(words[2]))
	file.close()


func _send_bonuses(button) -> void:
	for reciever in buttons[button.name].out_bonus:
		_update_bonuses(reciever.button)


func _apply_bonuses(sender : ButtonData, bonus : BonusData, reciever : ButtonData) -> void:
	if !reciever.in_bonus.has(sender):
		reciever.in_bonus[sender] = []
	if !sender.out_bonus.has(reciever):
		sender.out_bonus[reciever] = []
	reciever.in_bonus[sender].append(bonus)
	sender.out_bonus[reciever].append(bonus)


func _update_bonuses(button : Button) -> void:
	var quantity = 1
	buttons[button.name].per_click = 0
	buttons[button.name].per_second = 0
	for sender in buttons[button.name].in_bonus:
		if sender.add_resource != null:
			if sender.button.name != button.name:
				quantity = sender.add_resource.quantity
		for bonus in buttons[button.name].in_bonus[sender]:
			buttons[button.name].per_click += bonus.per_click * quantity
			buttons[button.name].per_second += bonus.per_second * quantity


func _add_button_data() -> void:
	for button in button_children:
		button.connect("gui_input",_on_button_pressed.bind(button))
		button.connect("mouse_entered",_on_button_hovered.bind(button))
		buttons[button.name].button = button
		buttons[button.name].label = button.get_parent().get_child(0)
		if !buttons[button.name].is_unlocked:
			button.get_parent().visible = false


func _add_notif(button : Button) -> void:
	var notif_icon = notif.instantiate()
	notif_icon.visible = true
	button.add_child(notif_icon)


func _unlock_buttons(button : Button) -> void:
	if buttons[button.name].is_unlocked:
		return
	if !buttons[button.name].perma_unlocked:
		return
	var unlock = true
	for resource in buttons[button.name].unlock_criteria:
		if resource.quantity < buttons[button.name].unlock_criteria[resource]:
			unlock = false
			break
	if unlock:
		buttons[button.name].is_unlocked = true
		button.get_parent().visible = true
		_add_notif(button)
		EventBus.emit_signal("unlock_button", button)


func _on_resource_timer_timeout() -> void:
	if !_check_time():
		buttons["ResourceTime"].unpause_timer = false
		return
	Player.total_seconds += 1
	for button in button_children:
		if buttons[button.name].add_resource != null:
			if buttons[button.name].unpause_timer and buttons[button.name].on_timer_active:
				buttons[button.name]._on_activate("second")
		else:
			buttons[button.name]._on_activate("second")


func _update_button_active(button : Button) -> void:
	if buttons[button.name].add_resource != null:
		if buttons[button.name].per_second > 0:
			buttons[button.name].on_timer_active = true


func _create_buttons() -> void:
	for button in buttons:
		var template = preload("res://scenes/buttontemplate.tscn").instantiate()
		template.name = button
		template.get_child(0).get_child(2).name = button
		loaded_buttons.add_child(template)
		template.position = buttons[button].position


func _on_visibility_changed(location) -> void:
	EventBus.emit_signal("vis_notif", location)


func _is_affordable(_resource) -> void:
	for in_button in button_children:
		var button = buttons[in_button.name]
		if button._check_cost(button.per_click):
			button.label.set("theme_override_colors/font_color",Color(255,255,255))
		else:
			button.label.set("theme_override_colors/font_color",Color(100,0,0))


func _get_child_buttons() -> void:
	button_children = []
	for template in loaded_buttons.get_children():
		button_children.append(template.get_child(0).get_child(2))


func _check_time() -> bool:
	if Player.max_seconds <= Player.total_seconds:
		return false
	return true
