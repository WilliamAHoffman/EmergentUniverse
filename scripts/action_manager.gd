extends Node

@export var button_manager_actions : Control

var actions : Dictionary

func _ready():
	_init_action_data()
	_init_action_button_data()


func _init_action_button_data():
	for button in button_manager_actions.get_children():
		actions[button.name].button = button
		button.connect("pressed",_on_action_button_pressed.bind(button.name))
		button.text = actions[button.name].button_text + "0"
		if !actions[button.name].is_unlocked:
			button.visible = false


func _init_action_data():
	actions["QuarkAction"] = ActionData.new()
	actions["QuarkAction"].name = "Quark Action"
	actions["QuarkAction"].button_text = "Quark Actions:"
	actions["QuarkAction"].cost["VirtualParticle"] = 2 


func _on_action_button_pressed():
	print("test")
