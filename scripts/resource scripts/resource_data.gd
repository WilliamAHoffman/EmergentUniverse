class_name ResourceData

# necessary variables

var name : String
var dict_name : String
var quantity := 1000
var total_quantity := 0
var perma_unlocked = true
var milestone = []
var knowledge = []

func check_milestone() -> void:
	if milestone.size() == 0:
		return
	
	if milestone[0] <= quantity:
		milestone.remove_at(0)
		Player.knowledge += knowledge[0];
		knowledge.remove_at(0)
