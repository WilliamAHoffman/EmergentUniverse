class_name ResourceManager
extends Node

var resources : Dictionary


func _ready():
	_import_resources_data("res://data/resource_data.txt")
	_apply_all_upgrades(resources)


func _import_resources_data(file_name):
	var file = FileAccess.open(file_name, FileAccess.READ)
	var dict_name = ""
	while !file.eof_reached():
		var line = file.get_line()
		if line != "":
			var words = line.split("==")
			if words[0] == "dict_name":
				dict_name = words[1]
				resources[dict_name] = ResourceData.new()
				resources[dict_name].dict_name = dict_name
			if words[0] == "name":
				resources[dict_name].name = words[1]
			if words[0] == "is_unlocked":
				if words[1] == "false":
					resources[dict_name].is_unlocked = false
				else:
					resources[dict_name].is_unlocked = true
			if words[0] == "in_quantity_per_click":
				resources[dict_name].in_quantity_per_click[words[1]] = int(words[2])
			if words[0] == "out_quantity_per_click":
				resources[dict_name].out_quantity_per_click[words[1]] = int(words[2])
			if words[0] == "in_quantity_per_second":
				resources[dict_name].in_quantity_per_second[words[1]] = int(words[2])
			if words[0] == "out_quantity_per_second":
				resources[dict_name].out_quantity_per_second[words[1]] = int(words[2])
			if words[0] == "in_multi_per_click":
				resources[dict_name].in_multi_per_click[words[1]] = int(words[2])
			if words[0] == "out_multi_per_click":
				resources[dict_name].out_multi_per_click[words[1]] = int(words[2])
			if words[0] == "in_multi_per_second":
				resources[dict_name].in_multi_per_second[words[1]] = int(words[2])
			if words[0] == "out_multi_per_second":
				resources[dict_name].out_multi_per_second[words[1]] = int(words[2])
	file.close()


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
