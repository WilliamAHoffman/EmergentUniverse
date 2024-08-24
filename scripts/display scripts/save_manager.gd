extends Node


@export var resource_manager : Node2D
@export var button_manager : Node2D
@export var bonus_manager : Node2D

func _on_save_quit_button_down() -> void:
	EventBus.emit_signal("save", "save", resource_manager.resources, button_manager.buttons, bonus_manager.bonuses)
	get_tree().quit()
