extends Node

@export var button_manager : ButtonManager
@export var resource_manager : ResourceManager
@export var bonus_manager : BonusManager
var buttons : Dictionary
var resources : Dictionary
var bonuses : Dictionary

func _ready() -> void:
	EventBus.connect("save", _save)

func _save(filename):
	#resources = resource_manager.resources
	#_save_resources(filename)
	pass

func _save_resources(filename : String) -> void:
	var file = FileAccess.open("res://data/saves/" + filename + "_resource.txt",FileAccess.WRITE)
	for resource in resources:
		pass
	file = null
	
