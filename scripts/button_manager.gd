extends Node

@export var button_manager : Control
var buttons : Dictionary
var resources : Dictionary


func _ready():
	_init_resource_data()
	_init_button_data()
	_add_button_data()


func _process(delta):
	_update_buttons()
	for button in button_manager.get_children():
		_unlock_buttons(button)

func _on_button_pressed(button):
	print(button)
	
	var cost_done = 0
	for resource in buttons[button.name].cost:
		if resource.quantity >= buttons[button.name].cost[resource]:
			cost_done += 1
	if cost_done >= buttons[button.name].cost.size():
		for resource in buttons[button.name].cost:
			resource.quantity -= buttons[button.name].cost[resource]
		for function in buttons[button.name].functions:
			print(function)
			callv(function, buttons[button.name].functions[function])


func _init_button_data():
	buttons["ResourceWaveFunction"] = ButtonData.new()
	buttons["ResourceWaveFunction"].functions['_add_click'] = [resources["WaveFunction"]]
	buttons["ResourceWaveFunction"].functions['_random_create'] = [resources["VirtualParticle"], 0, 50, 1]
	
	buttons["ResourceVirtualParticle"] = ButtonData.new()
	buttons["ResourceVirtualParticle"].functions['_add_click'] = [resources["VirtualParticle"]]
	buttons["ResourceVirtualParticle"].unlock_criteria[resources["VirtualParticle"]] = 1
	
	buttons["ActionQuark"] = ButtonData.new()
	buttons["ActionQuark"].functions['_random_create'] = [resources["UpQuark"], 0, 50, 1]
	buttons["ActionQuark"].functions['_random_create'] = [resources["DownQuark"], 50, 100, 1]
	buttons["ActionQuark"].unlock_criteria[resources["VirtualParticle"]] = 2
	buttons["ActionQuark"].cost[resources["VirtualParticle"]] = 2
	
	buttons["ResourceUpQuark"] = ButtonData.new()
	buttons["ResourceUpQuark"].unlock_criteria[resources["UpQuark"]] = 1
	
	buttons["ResourceDownQuark"] = ButtonData.new()
	buttons["ResourceDownQuark"].unlock_criteria[resources["DownQuark"]] = 1

func _init_resource_data():
	resources["VirtualParticle"] = ResourceData.new()
	resources["VirtualParticle"].name = "Virtual Particle"
	
	resources["WaveFunction"] = ResourceData.new()
	resources["WaveFunction"].name = "Wave Function"
	resources["WaveFunction"].quantity_per_click = 1
	
	resources["UpQuark"] = ResourceData.new()
	resources["UpQuark"].name = "Up Quark"
	
	resources["DownQuark"] = ResourceData.new()
	resources["DownQuark"].name = "Down Quark"


func _add_button_data():
	for button in button_manager.get_children():
		button.connect("pressed",_on_button_pressed.bind(button))
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


func _update_buttons():
	buttons["ResourceWaveFunction"].button.text = "Wave Functions: " + str(resources["WaveFunction"].quantity)
	buttons["ResourceVirtualParticle"].button.text = "Virtual Particles: " + str(resources["VirtualParticle"].quantity)
	buttons["ActionQuark"].button.text = "buy quarks: \n 2 Virtual Particles"
	buttons["ResourceUpQuark"].button.text = "Up Quarks: " + str(resources["UpQuark"].quantity)
	buttons["ResourceDownQuark"].button.text = "Down Quarks: " + str(resources["DownQuark"].quantity)

func _add_click(resource : ResourceData):
	if resource.is_unlocked:
		resource.quantity += resource.quantity_per_click

func _random_create(resource : ResourceData, lowerbound : int, upperbound : int, amount : int):
	var item_pull = randi_range(0, 100)
	if item_pull < randi_range(lowerbound, upperbound):
		resource.quantity += amount
