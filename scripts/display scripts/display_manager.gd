extends Control

@export var click_counter : Label
@export var second_counter : Label

func _physics_process(delta):
	click_counter.text = "Total clicks: " + str(Player.total_clicks) + "/" + str(Player.max_clicks)
	second_counter.text = "Total second: " + str(Player.total_seconds) + "/" + str(Player.max_seconds)
