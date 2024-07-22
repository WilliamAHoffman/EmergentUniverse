class_name ResourceData

var name : String
var quantity := 0
var quantity_per_click := 0
var quantity_per_second := 0
var is_unlocked = true
var bonus_quantity_per_click : Dictionary
var bonus_quantity_per_second : Dictionary
var bonus_multi_per_click : Dictionary
var bonus_multi_per_second : Dictionary

func _add_bonus(quantity_bonus):
	var quantity = 0
	for bonus in quantity_bonus:
		quantity += quantity_bonus[bonus]
	return quantity

func _multi_bonus(quantity_bonus):
	var quantity = 1
	for bonus in quantity_bonus:
		quantity *= quantity_bonus[bonus]
	return quantity
