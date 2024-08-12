extends Node

@export var button_manager : Node2D
var buttons : Dictionary
var lines : Array

func _ready():
	buttons = button_manager.buttons
	await owner.ready
	EventBus.connect("unlock_button", _create_lines)


func _create_lines(in_button : Button):
	for cost in buttons[in_button.name].cost:
		var newline = LineData.new()
		newline.line = Line2D.new()
		newline.reciever = buttons["Resource" + str(cost.dict_name)]
		newline.sender = buttons[in_button.name]
		newline.type = "cost"
		_draw_line(newline.sender.button, newline.reciever.button, newline.line)
		lines.append(newline)

func _draw_line(sender : Button, recieve : Button, line : Line2D):
	var start = Vector2(sender.position.x + sender.size.x/2, sender.position.y + sender.size.y/2)
	var end = Vector2(recieve.position.x + recieve.size.x/2, recieve.position.y + recieve.size.y/2)
	line.add_point(start)
	line.add_point(end)
	line.z_index = -1
	add_child(line)
