extends TabContainer


var parent_win : Browser
var tab_amount : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_tab("gergle")
	pass # Replace with function body.

func spawn_tab_ad(i : int):
	var t = PD.tab_ads.get(i).instance()
	add_tab(t)

func spawn_tab(name: String):
	var t = PD.tabs.get(name).instance()
	add_tab(t)
	pass



func add_tab(node : Node) -> void:
	tab_amount += 1
	node.tab_parent = self
	add_child(node)
	current_tab = get_tab_count() - 1
	node.connect("tab_info", self, "_close_tab")
	# This doesn't break because ad tabs are added on top of a browser which already has at least 1 tab
	if node is TabAd:
		parent_win.tab_ad_amount_manager(false)
	
	if node is PirateCreek:
		node.connect("download_state", parent_win, "_update_dl_state")
		node.connect("download_state", parent_win, "_update_dl_amount")
		
#	parent_win.window_content()
#	node.connect("move_to_top", self, "set_top_window")
#	node.connect("close_window", self, "close_window")
#	node._open_window()

func _close_tab(node : Node) -> void:
	tab_amount -= 1
	
	if node is TabAd:
		parent_win.tab_ad_amount_manager(true)
	
	if tab_amount <= 0:
		parent_win._on_Close_pressed()
	
	node.queue_free()
	
	pass
