class_name ResourceManager
extends Node

var resources : Dictionary


func _ready():
	_init_resource_data()
	for resource in resources:
		resources[resource].quantity_per_click = resources[resource]._add_bonus(resources[resource].bonus_quantity_per_click)
		resources[resource].quantity_per_second = resources[resource]._add_bonus(resources[resource].bonus_quantity_per_second)


func _init_resource_data():
	resources["Influence"] = ResourceData.new()
	resources["Influence"].name = "Influence"
	resources["Influence"].bonus_quantity_per_click["base"] = 1
	
	resources["VirtualParticle"] = ResourceData.new()
	resources["VirtualParticle"].name = "Virtual Particles"
	
	resources["WaveFunction"] = ResourceData.new()
	resources["WaveFunction"].name = "Wave Functions"
	resources["WaveFunction"].bonus_quantity_per_click["base"] = 1
	
	resources["UpQuark"] = ResourceData.new()
	resources["UpQuark"].name = "Up Quarks"
	
	resources["DownQuark"] = ResourceData.new()
	resources["DownQuark"].name = "Down Quarks"
