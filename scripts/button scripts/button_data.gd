class_name ButtonData


#Main variables
var main_text : String
var is_unlocked = false
var button : Button
var label : Label
var perma_unlocked = true
var sprite : Sprite2D
var in_bonus : Dictionary
var out_bonus : Dictionary
var position : Vector2

#Conditional variables
var cost : Dictionary #[ResourceData, int]
var unlock_criteria : Dictionary #[ResourceData, int]
var cost_scaling : float
var on_timer_active = false
var unpause_timer = false
var per_second = 0
var per_click = 0

#Functional variables
var add_resource = null #ResourceData #add_resources
var add_random_resources : Dictionary #Dictionary[ResourceData, Array[lower_chance : int, higher_chance : int, quantity : int]] #add_random_resources
var random_resource_efficiency : float


#Necessary Functions
func _on_activate(mode) -> void:
	
	
	var quantity = 0
	if mode == "click":
		if Player.max_clicks <= Player.total_clicks:
			return
		quantity = per_click
	if mode == "second":
		if Player.max_seconds <= Player.total_seconds:
			return
		quantity = per_second
	if mode == "single":
		if Player.max_clicks <= Player.total_clicks:
			return
		quantity = 1
	if quantity == 0:
		return
	if !_check_cost(quantity):
		return
	_subtract_cost(quantity)
	if add_resource != null:
		_add_resources(quantity, add_resource)
	if add_random_resources != null:
			if add_resource != null:
				_add_random_resources(quantity)
			else:
				_add_random_resources(quantity)
	if mode == "click":
		Player.total_clicks += 1
	if mode == "single":
		Player.total_clicks += 1
	EventBus.emit_signal("activate_button", button)


func update_text() -> void:
	label.text = main_text
	
	if add_resource != null:
		label.text += "\n" + add_resource.name + ": " + str(add_resource.quantity)
		if(per_click != 0):
			label.text += "\n" + "Per Click: " + str(per_click)
		if(per_second != 0):
			label.text += "\n" + "Per Second: " + str(per_second)
		if add_resource.milestone.size() > 0:
			label.text += "\n" + str(add_resource.knowledge[0]) + " knowledge at: " + str(add_resource.milestone[0]) 
	
	if cost.size() > 0:
		label.text += "\ncost: "
		for resource in cost:
			label.text += resource.name + " " + str(cost[resource]) +", "
		label.text = label.text.substr(0,label.text.length()-2)
	
	if on_timer_active:
		label.text += "\nactive: " + str(unpause_timer)



#Optional Functions
func _check_cost(times) -> bool:
	var cost_complete = true
	for resource in cost:
		if resource.quantity < cost[resource] * times:
			cost_complete = false
	if cost_complete:
		return true
	return false


func _subtract_cost(times) -> void:
	for resource in cost:
		resource.quantity -= cost[resource] * times
	
	for resource in cost:
		var scale = ceil(cost[resource] * (1 + cost_scaling))
		cost[resource] = scale


func _add_resources(quantity, resource) -> void:
	if resource.perma_unlocked:
		resource.quantity += quantity
		resource.total_quantity += quantity
		EventBus.emit_signal("gain_resource", resource)


func _add_random_resources(quantity_generated_from) -> void:
	var quantity_multi = quantity_generated_from * (random_resource_efficiency/100) + 1
	var rand_int = randi_range(0, 100)
	for resource in add_random_resources:
		if rand_int in range(add_random_resources[resource][0], add_random_resources[resource][1]):
			_add_resources(add_random_resources[resource][2] * quantity_multi, resource)
