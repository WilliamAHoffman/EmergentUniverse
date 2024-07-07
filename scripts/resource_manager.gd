extends Node

@export var button_manager : Control

var resources : Dictionary

func _ready():
	_init_resource_data()
	_init_button_data()

func _process(delta):
	_update_buttons()

func _init_resource_data():
	resources["Energy"] = ResourceData.new()
	resources["Energy"].name = "Energy"
	resources["Energy"].quantity_per_click = 1
	resources["Energy"].is_unlocked = true
	resources["Energy"].creation_percent["VirtualParticle"] = 10
	
	resources["VirtualParticle"] = ResourceData.new()
	resources["VirtualParticle"].name = "Virtual Particle"
	resources["VirtualParticle"].is_unlocked = false

func _on_resource_button_pressed(resource : String):
	if resources[resource].is_unlocked:
		resources[resource].quantity += resources[resource].quantity_per_click
		_random_creation(resource)

func _random_creation(resource : String):
	for item in resources[resource].creation_percent:
		var success_chance = randi_range(0,100)
		if success_chance <= resources[resource].creation_percent[item]:
			resources[item].quantity += 1

func _update_buttons():
	for button in button_manager.get_children():
		if resources[button.name].quantity > 0:
			resources[button.name].is_unlocked = true
		if resources[button.name].is_unlocked:
			button.visible = true
			resources[button.name].button.text = resources[button.name].name + ": " + str(resources[button.name].quantity)

func _init_button_data():
	for button in button_manager.get_children():
		resources[button.name].button = button
		button.connect("pressed",_on_resource_button_pressed.bind(button.name))
		if !resources[button.name].is_unlocked:
			button.visible = false
