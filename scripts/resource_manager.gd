extends Node

@export var button_manager_resources : Control

var resources : Dictionary

func _ready():
	_init_resource_data()
	_init_resource_button_data()

func _add_resource(resource: String, amount: int):
	resources[resource].quantity += amount
	resources[resource].button.text = resources[resource].name + "s: " + str(resources[resource].quantity)
	resources[resource].is_unlocked = true
	resources[resource].button.visible = true
	if resources[resource].creation_range != null:
		_random_creation(resource)

func _sub_resource(resource: String, amount: int):
	resources[resource].quantity -= amount
	resources[resource].button.text = resources[resource].flavor + str(resources[resource].quantity)

func _init_resource_data():
	resources["WaveFunction"] = ResourceData.new()
	resources["WaveFunction"].name = "Wave Function"
	resources["WaveFunction"].button_text = "Wave Functions: "
	resources["WaveFunction"].quantity_per_click = 1
	resources["WaveFunction"].is_unlocked = true
	resources["WaveFunction"].creation_range["VirtualParticle"] = [0, 50, 1]
	
	resources["VirtualParticle"] = ResourceData.new()
	resources["VirtualParticle"].name = "Virtual Particle"
	resources["VirtualParticle"].button_text = "Virtual Particles: "
	
	resources["UpQuark"] = ResourceData.new()
	resources["UpQuark"].name = "Up Quark"
	resources["UpQuark"].button_text = "Up Quarks: "
	
	resources["DownQuark"] = ResourceData.new()
	resources["DownQuark"].name = "Down Quark"
	resources["DownQuark"].button_text = "Down Quarks:"
	

func _on_resource_button_pressed(resource : String):
	if resources[resource].is_unlocked && resources[resource].quantity_per_click > 0:
		_add_resource(resource, resources[resource].quantity_per_click)

func _random_creation(resource : String):
	var item_pull = randi_range(0,100)
	for item in resources[resource].creation_range:
		if item_pull in range(resources[resource].creation_range[item][0], resources[resource].creation_range[item][1]):
			_add_resource(item, resources[resource].creation_range[item][2])

func _init_resource_button_data():
	for button in button_manager_resources.get_children():
		resources[button.name].button = button
		button.connect("pressed",_on_resource_button_pressed.bind(button.name))
		button.text = resources[button.name].button_text + "0"
		if !resources[button.name].is_unlocked:
			button.visible = false
