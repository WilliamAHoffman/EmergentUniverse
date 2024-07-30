class_name ButtonManager
extends Node

@export var button_manager : Control
@export var resource_manager : ResourceManager
var buttons : Dictionary
var resources : Dictionary


func _ready():
	await owner.ready
	resources = resource_manager.resources
	_init_button_data()
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

func _init_button_data():
	
	buttons["ResourceTime"] = ButtonData.new()
	buttons["ResourceTime"].add_resource = resources["Time"]
	
	buttons["ResourceInfluence"] = ButtonData.new()
	buttons["ResourceInfluence"].add_resource = resources["Influence"]
	
	buttons["ResourceWaveFunction"] = ButtonData.new()
	buttons["ResourceWaveFunction"].add_resource = resources["WaveFunction"]
	buttons["ResourceWaveFunction"].add_random_resources[resources["VirtualParticle"]] = [0, 50, 1]
	buttons["ResourceWaveFunction"].unlock_criteria[resources["Influence"]] = 5
	buttons["ResourceWaveFunction"].cost[resources["Influence"]] = 1
	
	buttons["ResourceVirtualParticle"] = ButtonData.new()
	buttons["ResourceVirtualParticle"].add_resource = resources["VirtualParticle"]
	buttons["ResourceVirtualParticle"].unlock_criteria[resources["VirtualParticle"]] = 1
	
	buttons["ActionQuark"] = ButtonData.new()
	buttons["ActionQuark"].unlock_criteria[resources["VirtualParticle"]] = 2
	buttons["ActionQuark"].add_random_resources[resources["UpQuark"]] = [0, 50, 1]
	buttons["ActionQuark"].add_random_resources[resources["DownQuark"]] = [50, 100, 1]
	buttons["ActionQuark"].main_text = "Create quarks"
	buttons["ActionQuark"].cost[resources["VirtualParticle"]] = 2
	buttons["ActionQuark"].times_activate_per_click = 1
	
	buttons["ResourceUpQuark"] = ButtonData.new()
	buttons["ResourceUpQuark"].add_resource = resources["UpQuark"]
	buttons["ResourceUpQuark"].unlock_criteria[resources["UpQuark"]] = 1
	
	buttons["ResourceDownQuark"] = ButtonData.new()
	buttons["ResourceDownQuark"].add_resource = resources["DownQuark"]
	buttons["ResourceDownQuark"].unlock_criteria[resources["DownQuark"]] = 1
	
	buttons["ShopQuantumFoam"] = ButtonData.new()
	buttons["ShopQuantumFoam"].add_resource = resources["QuantumFoam"]
	buttons["ShopQuantumFoam"].cost[resources["WaveFunction"]] = 5
	buttons["ShopQuantumFoam"].unlock_criteria[resources["WaveFunction"]] = 5
	buttons["ShopQuantumFoam"].cost_scaling = 0.20
	
	buttons["ShopEntanglement"] = ButtonData.new()
	buttons["ShopEntanglement"].add_resource = resources["Entanglement"]
	buttons["ShopEntanglement"].cost[resources["VirtualParticle"]] = 5
	buttons["ShopEntanglement"].unlock_criteria[resources["VirtualParticle"]] = 5
	buttons["ShopEntanglement"].cost_scaling = 0.20


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
