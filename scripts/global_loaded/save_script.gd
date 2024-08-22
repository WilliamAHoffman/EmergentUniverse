extends Node

@export var button_manager : Node2D
@export var resource_manager : Node2D
@export var bonus_manager : Node2D
var dl = "=="

func _ready() -> void:
	EventBus.connect("save", _save)

func _save(filename, resources, buttons, bonuses):
	_save_resources(filename, resources)
	_save_bonuses(filename, bonuses)

func _save_resources(filename : String, resources) -> void:
	var file = FileAccess.open("res://data/saves/" + filename + "_resource.txt",FileAccess.WRITE)
	for resource in resources:
		var item = resources[resource]
		file.store_string("dict_name" + dl + str(item.dict_name) + "\n")
		file.store_string("name" + dl + str(item.name) + "\n")
		file.store_string("quantity" + dl + str(item.quantity) + "\n")
		file.store_string("total_quantity" + dl + str(item.total_quantity) + "\n")
		file.store_string("perma_unlocked" + dl + str(item.perma_unlocked) + "\n")
	file = null

func _save_bonuses(filename : String, bonuses) -> void:
	var file = FileAccess.open("res://data/saves/" + filename + "_bonus.txt",FileAccess.WRITE)
	for bonus in bonuses:
		var item = bonuses[bonus]
		file.store_string("dict_name" + dl + str(item.dict_name) + "\n")
		file.store_string("per_click" + dl + str(item.per_click) + "\n")
		file.store_string("per_second" + dl + str(item.per_second) + "\n")
