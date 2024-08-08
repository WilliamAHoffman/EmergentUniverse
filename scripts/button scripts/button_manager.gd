class_name ButtonManager
extends Node

@export var button_manager : Control
@export var resource_manager : ResourceManager
@export var notif : PackedScene
var buttons : Dictionary
var resources : Dictionary
var button_children : Array

func _ready():
	await owner.ready
	resources = resource_manager.resources
	_import_button_data("res://data/button_data.txt")
	_create_buttons()
	_get_buttons()
	_add_button_data()


func _physics_process(delta):
	for button in button_children:
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
		buttons[button.name]._on_activate(buttons[button.name].add_resource.quantity_per_click)
		resource_manager._send_upgrades(buttons[button.name].add_resource, resources)
	else:
		buttons[button.name]._on_activate(buttons[button.name].times_activate_per_click)
	resource_manager._apply_all_upgrades(resources)


func _toggle_all():
	for button in button_children:
		buttons[button.name].unpause_timer = buttons["ResourceTime"].unpause_timer


func _right_click(button):
	if buttons[button.name].on_timer_active:
		if buttons[button.name].unpause_timer:
			buttons[button.name].unpause_timer = false
		else:
			buttons[button.name].unpause_timer = true
			buttons["ResourceTime"].unpause_timer = true
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
			elif words[0] == "times_activate_per_second":
				buttons[dict_name].times_activate_per_second = int(words[1])
			elif words[0] == "times_activate_per_click":
				buttons[dict_name].times_activate_per_click = int(words[1])
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
	file.close()


func _add_button_data():
	for button in button_children:
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
	var criterias_done = 0
	for resource in buttons[button.name].unlock_criteria:
		if resource.quantity >= buttons[button.name].unlock_criteria[resource]:
			criterias_done += 1
	if criterias_done >= buttons[button.name].unlock_criteria.size():
		buttons[button.name].is_unlocked = true
		button.visible = true
		_add_notif(button)


func _on_resource_timer_timeout():
	for button in button_children:
		if buttons[button.name].add_resource != null:
			if buttons[button.name].unpause_timer and buttons[button.name].on_timer_active:
				buttons[button.name]._on_activate(buttons[button.name].add_resource.quantity_per_second)
		else:
			buttons[button.name]._on_activate(buttons[button.name].times_activate_per_second)


func _update_button_active(button : Button):
	if buttons[button.name].add_resource != null:
		if buttons[button.name].add_resource.quantity_per_second > 0:
			buttons[button.name].on_timer_active = true


func _get_buttons():
	for container in button_manager.get_child(0).get_children():
		for button in container.get_children():
			button_children.append(button)


func _create_buttons():
	var button_template = preload("res://scenes/button_template.tscn")
	for button in buttons:
		for grid in button_manager.get_child(0).get_children():
			if grid.name == buttons[button].location:
				var button_instance = button_template.instantiate()
				button_instance.name = button
				grid.add_child(button_instance)


func _on_visibility_changed(location):
	EventBus.emit_signal("vis_notif", location)
