extends TextEdit

func _ready():
	var file = File.new()
	if file.file_exists("res://Documents/text.txt"):
		file.open("res://Documents/text.txt", File.READ)
		text = file.get_as_text()
		file.close()
	else:
		file.open("res://Documents/text.txt", File.WRITE)
		file.store_string("res://Documents/text.txt")
		file.close()

func _on_save():
	var file = File.new()
	file.open("res://Documents/text.txt", File.WRITE)
	file.store_string(text)
	file.close()
