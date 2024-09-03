extends Control

@export var click_counter : Label
@export var second_counter : Label
@export var coordinates : Label
@export var knowledge : Label
@export var camera : Camera2D

func _physics_process(_delta) -> void:
	click_counter.text = "Total clicks: " + str(Player.total_clicks) + "/" + str(Player.max_clicks)
	second_counter.text = "Total second: " + str(Player.total_seconds) + "/" + str(Player.max_seconds)
	coordinates.text = "(" + str(int(camera.position.x)) + "," + str(int(camera.position.y)) + ")"
	knowledge.text = "Knowledge: " + str(Player.knowledge)
