class_name ResourceManager
extends Node

var resources : Dictionary


func _ready():
	_import_resources_data("res://data/base/resource_data.txt")
	_import_resources_data("res://data/saves/save_resource.txt")

func _physics_process(delta: float) -> void:
	for resource in resources:
		resources[resource].check_milestone()


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
			elif words[0] == "name":
				resources[dict_name].name = words[1]
			elif words[0] == "is_unlocked":
				if words[1] == "false":
					resources[dict_name].is_unlocked = false
				else:
					resources[dict_name].is_unlocked = true
			elif words[0] == "quantity":
				resources[dict_name].quantity = int(words[1])
			elif words[0] == "total_quantity":
				resources[dict_name].total_quantity = int(words[1])
			elif words[0] == "perma_unlocked":
				if words[1] == "false":
					resources[dict_name].perma_unlocked = words[1]
				else:
					resources[dict_name].perma_unlocked = true
			elif words[0] == "milestone":
				resources[dict_name].milestone.append(int(words[1]))
	file.close()
