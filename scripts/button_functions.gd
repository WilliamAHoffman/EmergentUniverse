extends Node


func _add_resource(resource: ResourceData, amount: int):
	resource.quantity += amount


func _sub_resource(resource: ResourceData, amount: int):
	resource.quantity -= amount


func _random_creation(resource : ResourceData, upperBound : int, lowerBound : int, amount: int):
	var item_pull = randi_range(0,100)
	if item_pull in range(lowerBound, upperBound):
		_add_resource(resource, amount)
