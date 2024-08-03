class_name ButtonManager
extends Node

@export var button_manager : Control
@export var resource_manager : ResourceManager
var buttons : Dictionary
var resources : Dictionary


func _ready():
	await owner.ready
	resources = resource_manager.resources
	_import_button_data("C:/Users/whoff/OneDrive/Desktop/Godot Games/EmergentUniverse/data/button_data.txt")
	_add_button_data()


func _physics_process(delta):
	for button in button_manager.get_children():
		_unlock_buttons(button)
		buttons[button.name].update_text()
		_update_button_active(button)


func _on_button_pressed(event, button):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				_left_click(button)
			MOUSE_BUTTON_RIGHT:
				_right_click(button)


func _left_click(button):
	if buttons[button.name].add_resource != null:
		buttons[button.name]._on_activate(buttons[button.name].add_resource.quantity_per_click)
		resource_manager._send_upgrades(buttons[button.name].add_resource, resources)
	else:
		buttons[button.name]._on_activate(buttons[button.name].times_activate_per_click)
	resource_manager._apply_all_upgrades(resources)


func _right_click(button):
	if buttons[button.name].on_timer_active:
		if buttons[button.name].unpause_timer:
			buttons[button.name].unpause_timer = false
		else:
			buttons[button.name].unpause_timer = true


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
			if words[0] == "main_text":
				buttons[dict_name].main_text = words[1]
			if words[0] == "is_unlocked":
				if words[1] == "false":
					buttons[dict_name].is_unlocked = false
				else:
					buttons[dict_name].is_unlocked = true
			if words[0] == "cost":
				buttons[dict_name].cost[resources[words[1]]] = int(words[2])
			if words[0] == "unlock_criteria":
				buttons[dict_name].unlock_criteria[resources[words[1]]] = int(words[2])
			if words[0] == "cost_scaling":
				buttons[dict_name].cost_scaling = float(words[1])
			if words[0] == "on_timer_active":
				if words[1] == "false":
					buttons[dict_name].on_timer_active = false
				else:
					buttons[dict_name].on_timer_active = true
			if words[0] == "unpause_timer":
				if words[1] == "false":
					buttons[dict_name].unpause_timer = false
				else:
					buttons[dict_name].unpause_timer = true
			if words[0] == "times_activate_per_second":
				buttons[dict_name].times_activate_per_second = int(words[1])
			if words[0] == "times_activate_per_click":
				buttons[dict_name].times_activate_per_click = int(words[1])
			if words[0] == "add_resource":
				buttons[dict_name].add_resource = resources[words[1]]
			if words[0] == "add_random_resources":
				buttons[dict_name].add_random_resources[resources[words[1]]] = [int(words[2]),int(words[3]),int(words[4])]
			if words[0] == "random_resource_efficiency":
				buttons[dict_name].random_resource_efficiency = int(words[1])
	file.close()


func _add_button_data():
	for button in button_manager.get_children():
		button.connect("gui_input",_on_button_pressed.bind(button))
		buttons[button.name].button = button
		if !buttons[button.name].is_unlocked:
			button.visible = false


func _unlock_buttons(button : Button):
	var criterias_done = 0
	if !buttons[button.name].is_unlocked:
		for resource in buttons[button.name].unlock_criteria:
			if resource.quantity >= buttons[button.name].unlock_criteria[resource]:
				criterias_done += 1
		if criterias_done >= buttons[button.name].unlock_criteria.size():
			buttons[button.name].is_unlocked = true
	else:
		button.visible = true


func _on_resource_timer_timeout():
	for button in button_manager.get_children():
		if buttons[button.name].add_resource != null:
			if buttons[button.name].unpause_timer and buttons[button.name].on_timer_active:
				buttons[button.name]._on_activate(buttons[button.name].add_resource.quantity_per_second)
		else:
			buttons[button.name]._on_activate(buttons[button.name].times_activate_per_second)


func _update_button_active(button : Button):
	if buttons[button.name].add_resource != null:
		if buttons[button.name].add_resource.quantity_per_second > 0:
			buttons[button.name].on_timer_active = true
