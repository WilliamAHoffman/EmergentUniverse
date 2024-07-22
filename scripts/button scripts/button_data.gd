class_name ButtonData

#Main variables
var main_text : String
var is_unlocked = false
var button : Button


#Conditional variables
var cost : Dictionary #[ResourceData, int]
var unlock_criteria : Dictionary #[ResourceData, int]
var display_quantity : ResourceData


#Functional variables
var add_resource = null #ResourceData #add_resources
var add_random_resources : Dictionary #Dictionary[ResourceData, Array[lower_chance : int, higher_chance : int, quantity : int]] #add_random_resources
var random_resource_efficiency : int


#Necessary Functions
func _on_click():
	if _check_cost():
		_subtract_cost()
		if add_resource != null:
			_add_resources(add_resource.quantity_per_click)
		
		if add_random_resources != null:
			_add_random_resources(add_resource.quantity_per_click)


func _on_timer():
	if _check_cost():
		_subtract_cost()
		if add_resource != null:
			_add_resources(add_resource.quantity_per_second)
		
		if add_random_resources != null:
			_add_random_resources(add_resource.quantity_per_second)


func update_text():
	button.text = main_text
	if add_resource != null:
		button.text += add_resource.name + ": " + str(add_resource.quantity)
		if(add_resource.quantity_per_second != 0):
			button.text += "\n" + "Per Second: " + str(add_resource.quantity_per_second)
		if(add_resource.quantity_per_click != 0):
			button.text += "\n" + "Per Click: " + str(add_resource.quantity_per_click)
	
	if cost.size() > 0:
		button.text += "\n cost: "
		for resource in cost:
			button.text += resource.name + " " + str(cost[resource])


#Optional Functions
func _check_cost():
	var cost_complete = 0
	for resource in cost:
		if resource.quantity >= cost[resource]:
			cost_complete += 1
	if cost_complete == cost.size():
		return true
	return false


func _subtract_cost():
	for resource in cost:
		resource.quantity -= cost[resource]


func _add_resources(quantity):
	add_resource.quantity += quantity

func _add_random_resources(quantity_generated_from):
	var quantity_multi = (quantity_generated_from * (random_resource_efficiency/100)) + 1
	var rand_int = randi_range(0, 100)
	for resource in add_random_resources:
		if rand_int in range(add_random_resources[resource][0], add_random_resources[resource][1]):
			resource.quantity += (add_random_resources[resource][2] * quantity_multi)
