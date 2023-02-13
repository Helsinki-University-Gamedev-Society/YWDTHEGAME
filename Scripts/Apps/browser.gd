class_name Browser
extends ProgramWindow

signal tab_ad

signal dl_state



var game_manager : Node
var tab_ads : int = 0
enum dl_states {NONE = -1, STARTED = 0, ENDED = 1, STOPPED = 2} 
var dl = 0

# Amount of downloads occuring in a tab
var downloads : int = 0

func tab_ad_amount_manager(remove: bool) -> void:
	if remove:
		tab_ads -= 1
	else:
		tab_ads += 1
	emit_signal("tab_ad")
	pass

func window_parameters() -> void:
	window.parent_win = self
	win_size = Vector2(288, 192)
	$Icon.rect_size = win_size
	win_pos += Vector2(0,0)
	rect_position = win_pos
	pass

func window_content() -> void:
	window.rect_position = Vector2(2,dragbar.rect_size.y + 2)
	window.rect_size = $Icon.rect_size - Vector2(4,dragbar.rect_size.y + 12)
	
	var w : Node
	for n in window.get_child_count():
		w = window.get_child(n)
		if w is WindowTabs:
			w.set_tab_size(window.rect_size)
	print("Set size")
	pass

func _update_dl_state(d : int) -> void:
	dl = d
	emit_signal("dl_state", self, d, 1)
	pass

func _update_dl_amount(state : int):
	if state == 0:
		downloads += 1
	else:
		downloads -= 1
	pass

func _on_Close_pressed() -> void:
	print("close")
	#if dl == dl_states.STARTED:
	emit_signal("dl_state", self, 2, downloads)
	emit_signal("close_window", self)
	tab_ads = 0
	emit_signal("tab_ad")
	# There can be a timer for how long it takes before a window closes
	queue_free()
	pass
