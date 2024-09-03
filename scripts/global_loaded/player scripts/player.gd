extends Node

var total_clicks : int
var total_seconds : int
var max_clicks : int
var max_seconds : int
var knowledge : int

func _ready() -> void:
	_load_data("res://data/base/player_data.txt")
	if FileAccess.file_exists("res://data/saves/save_player.txt"):
		_load_data("res://data/saves/save_player.txt")

func _load_data(filename) -> void:
	var file = FileAccess.open(filename,FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		if line != "":
			var words = line.split("==")
			if words[0] == "total_clicks":
				total_clicks = int(words[1])
			if words[0] == "total_seconds":
				total_seconds = int(words[1])
			if words[0] == "max_clicks":
				max_clicks = int(words[1])
			if words[0] == "max_seconds":
				max_seconds = int(words[1])
			if words[0] == "knowledge":
				knowledge == int(words[1]) 
