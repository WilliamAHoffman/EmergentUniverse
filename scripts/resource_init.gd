extends Node

var resources : Dictionary

func _init_resource_data():
	resources["WaveFunction"] = ResourceData.new()
	resources["WaveFunction"].name = "Wave Function"
	resources["WaveFunction"].quantity_per_click = 1
	resources["WaveFunction"].is_unlocked = true
	
	resources["VirtualParticle"] = ResourceData.new()
	resources["VirtualParticle"].name = "Virtual Particle"
	
	resources["UpQuark"] = ResourceData.new()
	resources["UpQuark"].name = "Up Quark"
	
	resources["DownQuark"] = ResourceData.new()
	resources["DownQuark"].name = "Down Quark"


func _ready():
	_init_resource_data()
