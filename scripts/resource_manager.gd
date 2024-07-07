extends Node

@export var button_manager : Control

var resources : Dictionary

func _ready():
	_init_resource_data()
	_init_button_data()


func _init_resource_data():
	resources["Energy"] = ResourceData.new()
	resources["Energy"].name = "Energy"
	resources["Energy"].quantity_per_click = 1
	resources["Energy"].is_unlocked = true
	resources["Energy"].creation_percent["VitualParticle"] = 0.1
	
	resources["VirtualParticle"] = ResourceData.new()
	resources["VirtualParticle"].name = "Vitual Particle"
	resources["VirtualParticle"].is_unlocked = false

func _on_resource_button_pressed(resource : String):
	if resources[resource].is_unlocked:
		resources[resource].quantity += resources[resource].quantity_per_click
		resources[resource].button.text = resources[resource].name + ": " + str(resources[resource].quantity)


func _init_button_data():
	for button in button_manager.get_children():
		resources[button.name].button = button
		button.connect("pressed",_on_resource_button_pressed.bind(button.name))
