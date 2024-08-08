extends Control

@export var camera : Camera2D
@export var shop_teli : Button
@export var resource_teli : Button
@export var action_teli : Button
var resources : Dictionary
var camera_location = "Resources"

func _ready():
	EventBus.connect("vis_notif", visibility_notification)
	_add_button_data()


func visibility_notification(location):
	if location == "ResourceGrid" and camera_location != "Resources":
		resource_teli.get_child(0).visible = true
	if location == "ShopGrid" and camera_location != "Shop":
		shop_teli.get_child(0).visible = true
		shop_teli.visible = true
	if location == "ActionGrid" and camera_location != "Action":
		action_teli.get_child(0).visible = true
		action_teli.visible = true


func _on_button_pressed(location):
	camera_location = location
	if camera_location == "Resource":
		camera.position.x = 0
		resource_teli.get_child(0).visible = false
	if camera_location == "Shop":
		camera.position.x = get_viewport().size.x
		shop_teli.get_child(0).visible = false
	if camera_location == "Action":
		camera.position.x = get_viewport().size.x * 2
		action_teli.get_child(0).visible = false


func _add_button_data():
	for button in self.get_child(0).get_children():
		print(button.name)
		button.connect("pressed",_on_button_pressed.bind(button.name))


