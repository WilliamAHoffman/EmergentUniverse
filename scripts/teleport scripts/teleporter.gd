extends Control

@export var camera : Camera2D
@export var EventBus : Node2D

func _ready():
	EventBus.connect("vis_notif", visibility_notification)
	print("connect")


func visibility_notification(location):
	if location == "ResourceGrid":
		print(self.get_child(0).get_child(1).name)
	if location == "ShopGrid":
		print(self.get_child(0).get_child(0).name)


func _on_shop_button_down():
	camera.position.x = 1152


func _on_resources_button_down():
	camera.position.x = 0

