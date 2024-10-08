extends Camera2D

var mouse_start_pos
var screen_start_position

var dragging = false


func _physics_process(_delta) -> void:
	_zoom()


func _zoom() -> void:
	if Input.is_action_just_released('wheel_down'):
		if get_zoom().length() - Vector2(0.1, 0.1).length() != 0:
			set_zoom(get_zoom() - Vector2(0.1, 0.1))
	if Input.is_action_just_released('wheel_up'):
		if get_zoom().length() + Vector2(0.1, 0.1).length() != 0 and get_zoom() < Vector2(3,3):
			set_zoom(get_zoom() + Vector2(0.1, 0.1))


func _input(event) -> void:
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = sqrt(get_viewport().size.y - 300) * 0.1 * (mouse_start_pos - event.position) + screen_start_position
