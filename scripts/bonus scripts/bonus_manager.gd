class_name BonusManager
extends Node

var bonuses : Dictionary

func _ready():
	_import_bonus_data("res://data/base/bonus_data.txt")
	_import_bonus_data("res://data/saves/save_bonus.txt")


func _import_bonus_data(file_name) -> void:
	var file = FileAccess.open(file_name, FileAccess.READ)
	var dict_name = ""
	while !file.eof_reached():
		var line = file.get_line()
		if line != "":
			var words = line.split("==")
			if words[0] == "dict_name":
				dict_name = words[1]
				bonuses[dict_name] = BonusData.new()
				bonuses[dict_name].dict_name = dict_name
			if words[0] == "per_click":
				bonuses[dict_name].per_click = int(words[1])
			if words[0] == "per_second":
				bonuses[dict_name].per_second = int(words[1])
