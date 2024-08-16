extends Node

@export var button_manager : Node2D
var buttons : Dictionary
var lines : Array

func _ready():
	buttons = button_manager.buttons
	await owner.ready
	EventBus.connect("unlock_button", _create_all_lines)


func _check_all_lines():
	for line in lines:
		if !line.line.visible:
			if line.sender.is_unlocked and line.reciever.is_unlocked:
				line.line.visible = true


func _create_all_lines(in_button):
	_create_lines(in_button, buttons[in_button.name].cost, "cost", Color(96,96,96))
	_create_lines(in_button, buttons[in_button.name].add_random_resources, "random", Color(102,0,102))
	
	_check_all_lines()


func _create_lines(in_button : Button, recievers, type : String, color : Color):
	for item in recievers:
		var newline = LineData.new()
		newline.line = Line2D.new()
		newline.reciever = buttons["Resource" + str(item.dict_name)]
		newline.sender = buttons[in_button.name]
		newline.type = type
		newline.line.default_color = color
		_draw_line(newline.sender.button, newline.reciever.button, newline.line)
		lines.append(newline)

func _draw_line(sender : Button, reciever : Button, line : Line2D):
	var sender_pos = buttons[sender.name].position
	var reciever_pos = buttons[reciever.name].position
	var start = Vector2(sender_pos.x + sender.get_parent().size.x/2, sender_pos.y + sender.get_parent().size.y/2)
	var end = Vector2(reciever_pos.x + reciever.get_parent().size.x/2, reciever_pos.y + reciever.get_parent().size.y/2)
	line.add_point(start)
	line.add_point(end)
	line.z_index = -1
	line.visible = false
	add_child(line)
