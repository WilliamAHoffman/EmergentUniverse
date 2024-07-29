class_name ResourceManager
extends Node

var resources : Dictionary


func _ready():
	_init_resource_data()
	_apply_all_upgrades(resources)

func _init_resource_data():
	
	resources["Time"] = ResourceData.new()
	resources["Time"].name = "Time"
	resources["Time"].dict_name = "Time"
	resources["Time"].in_quantity_per_second["base"] = 1
	
	resources["Influence"] = ResourceData.new()
	resources["Influence"].name = "Influence"
	resources["Influence"].dict_name = "Influence"
	resources["Influence"].in_quantity_per_click["base"] = 1
	
	resources["VirtualParticle"] = ResourceData.new()
	resources["VirtualParticle"].name = "Virtual Particles"
	resources["VirtualParticle"].dict_name = "VirtualParticle"
	
	resources["WaveFunction"] = ResourceData.new()
	resources["WaveFunction"].name = "Wave Functions"
	resources["WaveFunction"].dict_name = "WaveFunctions"
	resources["WaveFunction"].in_quantity_per_click["base"] = 1
	
	resources["UpQuark"] = ResourceData.new()
	resources["UpQuark"].name = "Up Quarks"
	resources["UpQuark"].dict_name = "UpQuarks"
	
	resources["DownQuark"] = ResourceData.new()
	resources["DownQuark"].name = "Down Quarks"
	resources["DownQuark"].dict_name = "DownQuarks"
	
	resources["QuantumFoam"] = ResourceData.new()
	resources["QuantumFoam"].name = "Quantum Foam"
	resources["QuantumFoam"].dict_name = "QuantumFoam"
	resources["QuantumFoam"].out_quantity_per_second["Influence"] = 1
	resources["QuantumFoam"].in_quantity_per_click["base"] = 1


func _apply_all_upgrades(resources : Dictionary):
		for resource in resources:
			resources[resource].quantity_per_click = _apply_add_upgrades(resources[resource], resources[resource].in_quantity_per_click, resources)
			resources[resource].quantity_per_second = _apply_add_upgrades(resources[resource], resources[resource].in_quantity_per_second, resources)
			resources[resource].quantity_per_click *= _apply_multi_upgrades(resources[resource], resources[resource].in_multi_per_click, resources)
			resources[resource].quantity_per_second *= _apply_multi_upgrades(resources[resource], resources[resource].in_multi_per_second, resources)


func _apply_add_upgrades(resource : ResourceData, upgrades : Dictionary, resources : Dictionary):
	var quantity = 0
	for upgrade in upgrades:
		if upgrade == "base":
			quantity += upgrades[upgrade]
		else:
			quantity += (upgrades[upgrade] * resources[upgrade].quantity)
	return quantity


func _apply_multi_upgrades(resource : ResourceData, upgrades : Dictionary, resources : Dictionary):
	var quantity = 1
	for upgrade in upgrades:
		if upgrade == "base":
			quantity *= upgrades[upgrade]
		else:
			quantity *= (upgrades[upgrade] + resources[upgrade].quantity)
	return quantity

func _send_upgrades(resource : ResourceData, resources : Dictionary):
	
	for upgrade in resource.out_multi_per_click:
		resources[upgrade].in_multi_per_click[resource.dict_name] = resource.out_multi_per_click[upgrade]

	for upgrade in resource.out_multi_per_second:
		resources[upgrade].in_multi_per_second[resource.dict_name] = resource.out_multi_per_second[upgrade]

	for upgrade in resource.out_quantity_per_click:
		resources[upgrade].in_quantity_per_click[resource.dict_name] = resource.out_quantity_per_click[upgrade]

	for upgrade in resource.out_quantity_per_second:
		resources[upgrade].in_quantity_per_second[resource.dict_name] = resource.out_quantity_per_second[upgrade]
