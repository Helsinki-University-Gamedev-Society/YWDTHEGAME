class_name Paint
extends ProgramWindow


func window_parameters() -> void:
	win_size = Vector2(320, 200)
	$Icon.rect_size = win_size
	win_pos += Vector2(0,0)
	rect_position = win_pos
	pass

func window_content() -> void:
	window.rect_position = Vector2(2,dragbar.rect_size.y + 2)
	#window.rect_size = $Icon.rect_size - Vector2(4,dragbar.rect_size.y + 12)
	pass

