extends Node

@export var button_manager : Control

var resources : Dictionary

func _ready():
	_init_resource_data()
	_init_resource_button_data()


func _process(delta):
	_update_buttons()


func _init_resource_data():
	resources["WaveFunction"] = ResourceData.new()
	resources["WaveFunction"].name = "Wave Function"
	resources["WaveFunction"].quantity_per_click = 1
	resources["WaveFunction"].is_unlocked = true
	resources["WaveFunction"].creation_range["VirtualParticle"] = [0, 10, 1]
	
	resources["VirtualParticle"] = ResourceData.new()
	resources["VirtualParticle"].name = "Virtual Particle"
	
	resources["UpQuark"] = ResourceData.new()
	resources["UpQuark"].name = "Up Quark"
	
	resources["DownQuark"] = ResourceData.new()
	resources["DownQuark"].name = "Up Quark"

func _on_resource_button_pressed(resource : String):
	if resources[resource].is_unlocked && resources[resource].quantity_per_click > 0:
		resources[resource].quantity += resources[resource].quantity_per_click
		if resources[resource].creation_range != null:
			_random_creation(resource)


func _random_creation(resource : String):
	var item_pull = randi_range(0,100)
	for item in resources[resource].creation_range:
		if item_pull in range(resources[resource].creation_range[item][0], resources[resource].creation_range[item][1]):
			resources[item].quantity += resources[resource].creation_range[item][2]


func _update_buttons():
	for button in button_manager.get_children():
		if resources[button.name].quantity > 0:
			resources[button.name].is_unlocked = true
		if resources[button.name].is_unlocked:
			button.visible = true
			resources[button.name].button.text = resources[button.name].name + "s: " + str(resources[button.name].quantity)


func _init_resource_button_data():
	print(button_manager)
	for button in button_manager.get_children():
		resources[button.name].button = button
		button.connect("pressed",_on_resource_button_pressed.bind(button.name))
		if !resources[button.name].is_unlocked:
			button.visible = false
