extends Node

@export var lastsaved : Timer
@export var savelabel : Label
var allowed_characters = ["a","b","c","d","e","f","g","h","i","j","k","l","m",
"n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"]
var seconds = 0

func _process(delta: float) -> void:
	_saved_time()


func _on_input_text_submitted(new_text: String) -> void:
	for char in new_text:
		if !allowed_characters.has(char):
			new_text = new_text.replace(char, "*")
	EventBus.emit_signal("save", new_text)
	savelabel.visible = true
	seconds = 0
	lastsaved.start()

func _saved_time() -> void:
	savelabel.text = "Last saved: "
	savelabel.text += str(int(seconds/60))
	savelabel.text += " minutes ago"
	


func _on_last_saved_timeout() -> void:
	seconds += 1
