class_name ResourceManager
extends Node

var resources : Dictionary


func _ready():
	_init_resource_data()


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
