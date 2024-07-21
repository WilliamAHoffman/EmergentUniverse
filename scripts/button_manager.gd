class_name ButtonManager
extends Node

@export var button_manager : Control
@export var resource_manager : ResourceManager
var buttons : Dictionary
var resources : Dictionary


func _ready():
	await owner.ready
	resources = resource_manager.resources
	_init_button_data()
	_add_button_data()


func _physics_process(delta):
	for button in button_manager.get_children():
		_unlock_buttons(button)
		buttons[button.name].update_text()

func _on_button_pressed(button):
	print(button)
	buttons[button.name]._on_click()


func _init_button_data():
	buttons["ResourceWaveFunction"] = ButtonData.new()
	buttons["ResourceWaveFunction"].add_resource = resources["WaveFunction"]
	buttons["ResourceWaveFunction"].add_random_resources[resources["VirtualParticle"]] = [0, 50, 1]
	
	buttons["ResourceVirtualParticle"] = ButtonData.new()
	buttons["ResourceVirtualParticle"].add_resource = resources["VirtualParticle"]
	buttons["ResourceVirtualParticle"].unlock_criteria[resources["VirtualParticle"]] = 1
	
	buttons["ActionQuark"] = ButtonData.new()
	buttons["ActionQuark"].unlock_criteria[resources["VirtualParticle"]] = 2
	buttons["ActionQuark"].add_random_resources[resources["UpQuark"]] = [0, 50, 1]
	buttons["ActionQuark"].add_random_resources[resources["DownQuark"]] = [50, 100, 1]
	buttons["ActionQuark"].main_text = "Create quarks"
	buttons["ActionQuark"].cost[resources["VirtualParticle"]] = 2
	
	buttons["ResourceUpQuark"] = ButtonData.new()
	buttons["ResourceUpQuark"].unlock_criteria[resources["UpQuark"]] = 1
	
	buttons["ResourceDownQuark"] = ButtonData.new()
	buttons["ResourceDownQuark"].unlock_criteria[resources["DownQuark"]] = 1


func _add_button_data():
	for button in button_manager.get_children():
		button.connect("pressed",_on_button_pressed.bind(button))
		buttons[button.name].button = button
		if !buttons[button.name].is_unlocked:
			button.visible = false


func _unlock_buttons(button : Button):
	var criterias_done = 0
	if !buttons[button.name].is_unlocked:
		for resource in buttons[button.name].unlock_criteria:
			if resource.quantity >= buttons[button.name].unlock_criteria[resource]:
				criterias_done += 1
		if criterias_done >= buttons[button.name].unlock_criteria.size():
			buttons[button.name].is_unlocked = true
	else:
		button.visible = true

