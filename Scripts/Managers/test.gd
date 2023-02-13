extends Control

# Sends a signal if the amount of downloads changed
signal dl_change

const ad_threshold : Array = [3, 5, 7]

onready var screen = $CanvasLayer/ColorRect

var total_score : int = 0
var multiplier : int = 0

var temp_pc : int = 0
var temp_room : int = 0

# Number of windows
var win_amount : int = 0

var browsers : Array = []

# Number of minimized windows
var win_mini : int = 0
# Number of window ads
var ad_windows : int = 0
# Number of total ads
var ad_amount : int = 0


# These vars are used for managing the "download" 
var downloads : Array = []
var scores : Array = []


func download_manager(node : Node, dl_state: int) -> void:
	
	match dl_state:
		# Download has begun
		0: 
			downloads.append(node)
			scores.append(0)
		# Download has ended
		1:
			var b = downloads.find(node)
			if b > -1:
				downloads.remove(b)
		# Download has been interrupted
		_:
			var b = downloads.find(node)
			if b > -1:
				downloads.remove(b)
			pass
	emit_signal("dl_change")
	pass

func point_manager(points : int):
	total_score += points
	pass

func score_manager():
	for n in scores.size():
		scores[n] += 1

## Called when the node enters the scene tree for the first time.
#func _ready():
#	spawn_ad()
#	pass # Replace with function body.

func spawn_window(app: String) -> void:
	var a = PD.prefabs.get(app).instance()
	add_window(a)
#	for n in 5:
#		var b = PD.prefabs.get("basicAd").instance()
#		add_window(b)
	
#	var b = PD.prefabs.get("webBrowser").instance()
#	add_window(b)
#	
#	var c = PD.prefabs.get("adBounce").instance()
#	add_window(c)
	
#	$ComputerScreen.add_child(c)
#	c.monitor_info[0] = $ComputerScreen.rect_position
#	c.monitor_info[1] = $ComputerScreen.rect_size
#	c.connect("move_to_top", self, "set_top_window")
#	c._open_window()
	
	pass

func calculate_ads() -> void:
	var a : int = 0
	for n in browsers.size():
		a += browsers[n].tab_ads
	ad_amount = a + ad_windows
	#print("Ads are ", ad_amount)
	$DebugNode/AdAmount.text = "Ad Amount: " + str(ad_amount)
	pass


func add_window(node : Node) -> void:
	if node is ProgramWindow:
		window_amount_manager(false)
		if node is Browser:
			node.game_manager = self
			node.connect("tab_ad", self, "calculate_ads")
			browsers.append(node)
		
		if node is Ad:
			ad_window_amount(false)
		$ComputerScreen.add_child(node)
		node.monitor_info[0] = $ComputerScreen.rect_global_position
		node.monitor_info[1] = $ComputerScreen.rect_size
		
		if node is Browser:
			node.win_pos = Vector2(1,2) * (win_amount-1)
		
		node.connect("move_to_top", self, "set_top_window")
		node.connect("close_window", self, "close_window")
		node._open_window()
		
	pass

func set_top_window(node : Node) -> void:
	$ComputerScreen.move_child(node, $ComputerScreen.get_child_count() - 1)
	pass

# Used to manage whether an ad is added or removed
func ad_window_amount(remove: bool) -> void:
	if remove:
		ad_windows -= 1
	else:
		ad_windows += 1
	calculate_ads()

func window_amount_manager(remove: bool) -> void:
	if remove:
		win_amount -= 1
	else:
		win_amount += 1
	$DebugNode/WindowAmount.text = "Window Amount: " + str(win_amount)

func close_window(node : Node) -> void:
	var b = browsers.find(node)
	if b > -1:
		browsers.remove(b)
	window_amount_manager(true)
	if node is Ad:
		ad_window_amount(true)
	pass

#func close_tab(tab : Node):
#	if tab.is_ad:
#		ad_window_amount(true)
#	pass

func _process(delta):
	
	pass


func computer_state():
	
	
	pass



#func ad_handler():
#
#	pass
