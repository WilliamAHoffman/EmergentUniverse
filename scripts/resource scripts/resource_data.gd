class_name ResourceData

# necessary variables

var name : String
var dict_name : String
var quantity := 100
var total_quantity := 100
var perma_unlocked = true
var milestone = []

func check_milestone() -> void:
	if milestone.size() == 0:
		return
	
	if milestone[0] <= quantity:
		milestone.remove_at(0)
		Player.knowledge += 1;
