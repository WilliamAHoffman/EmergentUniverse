extends Node

@export var button_manager : Node2D
var buttons : Dictionary
var lines : Array

func _ready() -> void:
	EventBus.connect("unlock_button", _check_all_lines)
	EventBus.connect("finishbuttons", _create_every_line)



func _create_every_line(buttondict : Dictionary) -> void:
	buttons = buttondict
	for button in buttons:
		_create_all_lines(buttons[button])


func _check_all_lines(_button) -> void:
	for line in lines:
		if !line.line.visible:
			if line.sender.is_unlocked and line.reciever.is_unlocked:
				line.line.visible = true


func _create_all_lines(in_button : ButtonData) -> void:
	_create_lines(in_button.button, in_button.cost, "cost", Color(96,96,96,0.5))
	_create_lines(in_button.button, in_button.add_random_resources, "random", Color(102,0,102,0.3))
	_check_all_lines(in_button.button)


func _create_lines(in_button : Button, recievers, type : String, color : Color) -> void:
	for item in recievers:
		var newline = LineData.new()
		newline.line = Line2D.new()
		newline.reciever = buttons["Resource" + str(item.dict_name)]
		newline.sender = buttons[in_button.name]
		newline.type = type
		newline.line.default_color = color
		_draw_line(newline.sender.button, newline.reciever.button, newline.line)
		lines.append(newline)

func _draw_line(sender : Button, reciever : Button, line : Line2D) -> void:
	var sender_pos = buttons[sender.name].position
	var reciever_pos = buttons[reciever.name].position
	var start = Vector2(sender_pos.x + sender.get_parent().size.x/2, sender_pos.y + sender.get_parent().size.y/2)
	var end = Vector2(reciever_pos.x + reciever.get_parent().size.x/2, reciever_pos.y + reciever.get_parent().size.y/2)
	line.add_point(start)
	line.add_point(end)
	line.z_index = -1
	line.visible = false
	add_child(line)
