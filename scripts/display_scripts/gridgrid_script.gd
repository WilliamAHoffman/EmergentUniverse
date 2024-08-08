extends HBoxContainer

func _ready():
	print(get_viewport_rect().size.x)
	self.size.x = get_viewport_rect().size.x * self.get_child_count()
	self.size.y = get_viewport_rect().size.y
