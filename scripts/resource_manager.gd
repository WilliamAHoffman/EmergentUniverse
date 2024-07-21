class_name ResourceManager
extends Node

var resources : Dictionary


func _ready():
	_init_resource_data()


func _init_resource_data():
	resources["VirtualParticle"] = ResourceData.new()
	resources["VirtualParticle"].name = "Virtual Particles"
	
	resources["WaveFunction"] = ResourceData.new()
	resources["WaveFunction"].name = "Wave Functions"
	resources["WaveFunction"].quantity_per_click = 1
	
	resources["UpQuark"] = ResourceData.new()
	resources["UpQuark"].name = "Up Quarks"
	
	resources["DownQuark"] = ResourceData.new()
	resources["DownQuark"].name = "Down Quarks"
