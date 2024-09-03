extends Node

@export var button_manager : Node2D
@export var resource_manager : Node2D
@export var bonus_manager : Node2D
var dl = "=="


func _ready() -> void:
	_create_saves()
	#EventBus.connect("save", _save)


func _save(filename, resources, buttons, bonuses):
	_save_resources(filename, resources)
	_save_bonuses(filename, bonuses)
	_save_buttons(filename, buttons)
	_save_player(filename)


func _save_player(filename) -> void:
	var file = FileAccess.open("res://data/saves/" + filename + "_player.txt",FileAccess.WRITE)
	file.store_string("total_clicks" + dl + str(Player.total_clicks) + "\n")
	file.store_string("total_seconds" + dl + str(Player.total_seconds) + "\n")
	file.store_string("max_seconds" + dl + str(Player.max_seconds) + "\n")
	file.store_string("max_clicks" + dl + str(Player.max_clicks) + "\n")
	file.store_string("knowledge" + dl + str(Player.knowledge) + "\n")

func _save_resources(filename : String, resources) -> void:
	var file = FileAccess.open("res://data/saves/" + filename + "_resource.txt",FileAccess.WRITE)
	for resource in resources:
		var item = resources[resource]
		file.store_string("dict_name" + dl + str(item.dict_name) + "\n")
		file.store_string("name" + dl + str(item.name) + "\n")
		file.store_string("quantity" + dl + str(item.quantity) + "\n")
		file.store_string("total_quantity" + dl + str(item.total_quantity) + "\n")
		file.store_string("perma_unlocked" + dl + str(item.perma_unlocked) + "\n")
		file.store_string(_save_array(item.milestone, "milestone"))
		file.store_string("\n")


func _save_bonuses(filename : String, bonuses) -> void:
	var file = FileAccess.open("res://data/saves/" + filename + "_bonus.txt",FileAccess.WRITE)
	for bonus in bonuses:
		var item = bonuses[bonus]
		file.store_string("dict_name" + dl + str(item.dict_name) + "\n")
		file.store_string("per_click" + dl + str(item.per_click) + "\n")
		file.store_string("per_second" + dl + str(item.per_second) + "\n")
		file.store_string("\n")


func _save_buttons(filename : String, buttons) -> void:
	var file = FileAccess.open("res://data/saves/" + filename + "_button.txt",FileAccess.WRITE)
	for button in buttons:
		var item = buttons[button]
		#print("thing: " + button)
		file.store_string("dict_name" + dl + str(button) + "\n")
		file.store_string("main_text" + dl + str(item.main_text) + "\n")
		file.store_string("is_unlocked" + dl + str(item.is_unlocked) + "\n")
		file.store_string("perma_unlocked" + dl + str(item.perma_unlocked) + "\n")
		file.store_string(_save_bonus(item.out_bonus, item.in_bonus, dl))
		file.store_string("pos" + dl + str(item.position.x) + dl + str(item.position.y) + "\n")
		file.store_string(_save_dict(item.cost, "cost", dl))
		file.store_string(_save_dict(item.unlock_criteria, "unlock_criteria", dl))
		file.store_string("cost_scaling" + dl + str(item.cost_scaling) + "\n")
		if item.add_resource != null:
			file.store_string("add_resource" + dl + item.add_resource.dict_name + "\n")
		file.store_string(_save_random(item.add_random_resources, dl))
		file.store_string("random_resource_efficiency" + dl + str(item.random_resource_efficiency) + "\n")
		file.store_string("\n")


func _save_array(array, item_name) -> String:
	var lines = ""
	for item in array:
		lines += item_name + dl + str(item) + "\n"
	return lines

func _save_bonus(out_bonus : Dictionary, in_bonus : Dictionary, dl) -> String:
	var bonus_lines = ""
	for item in out_bonus:
		for bonus in out_bonus[item]:
			bonus_lines += "bonus" + dl + bonus.dict_name + dl + item.button.name + "\n"
	return bonus_lines

func _save_dict(dict : Dictionary, item_name : String, dl) -> String:
	var lines = ""
	for item in dict:
		#print(name + " " + item.dict_name)
		lines += item_name + dl + item.dict_name + dl + str(dict[item]) + "\n"
	return lines

func _save_random(dict : Dictionary, dl) -> String:
	var lines = ""
	for item in dict:
		lines += "add_random_resources" + dl + item.dict_name + dl + str(dict[item][0]) + dl + str(dict[item][1]) + dl + str(dict[item][2]) + "\n"
	return lines

func _create_saves() -> void:
	if !FileAccess.file_exists("res://data/saves/save_bonus.txt"):
		FileAccess.open("res://data/saves/save_bonus.txt",FileAccess.WRITE)
	if !FileAccess.file_exists("res://data/saves/save_button.txt"):
		FileAccess.open("res://data/saves/save_button.txt",FileAccess.WRITE)
	if !FileAccess.file_exists("res://data/saves/save_resource.txt"):
		FileAccess.open("res://data/saves/save_resource.txt",FileAccess.WRITE)
	if !FileAccess.file_exists("res://data/saves/save_player.txt"):
		FileAccess.open("res://data/saves/save_player.txt",FileAccess.WRITE)

func _erase_saves()-> void:
	FileAccess.open("res://data/saves/save_bonus.txt",FileAccess.WRITE)
	FileAccess.open("res://data/saves/save_button.txt",FileAccess.WRITE)
	FileAccess.open("res://data/saves/save_resource.txt",FileAccess.WRITE)
	FileAccess.open("res://data/saves/save_player.txt",FileAccess.WRITE)
