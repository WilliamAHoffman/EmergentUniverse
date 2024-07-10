extends Node

@export var button_manager : Control
var buttons : Dictionary

func _ready():
	_init_button_data()


func _on_button_pressed(button):
	print(button.name)
	print(buttons[button])


func _init_button_data():
	for button in button_manager.get_children():
		button.connect("pressed",_on_button_pressed.bind(button))
		
		buttons[button] = ButtonData.new()
