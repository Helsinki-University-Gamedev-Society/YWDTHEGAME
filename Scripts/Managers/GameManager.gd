extends Control

# Sends a signal if the amount of downloads changed
#signal dl_change

const ad_threshold : Array = [3, 5, 7]
const ad_freq : float = 10.0

onready var screen = $CanvasLayer/ColorRect
onready var pc_fan = $PCFan

var rng = RandomNumberGenerator.new()

var total_score : int = 0
var c_dls : int = 0

var high_multi : int = 0
var cur_multi : int = 0

var meter : float = 0.0

var start_time : bool = false
var player_time : float = 0.00

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
var is_dl : bool = false


func _start_computer():
	rng.randomize()
	computer_state()



func download_manager(node : Browser, dl_state: int, amount : int) -> void:
	# This is to prevent the the timer from starting by simply closing the browser
	if not start_time and dl_state != 2:
		start_time = true
	for n in amount:
		match dl_state:
			# Download has begun
			0: 
				downloads.append(node)
				scores.append(0)
			# Download has ended
			1:
				var b = downloads.size() - 1
				if b > -1:
					total_score += scores[b]
					completed_downloads(true)
					downloads.remove(b)
					scores.remove(b)
				
			# Download has been interrupted
			_:
				# This is the current replacement
				var b = downloads.size() - 1
#				var b = downloads.find(node)
				if b > -1:
					completed_downloads(false)
					downloads.remove(b)
					scores.remove(b)
				pass
	if not is_dl:
		is_dl = true
		score_manager()
		manage_ads()
	pass

func score_manager():
	if scores.size() < 1:
		print("no downloads")
		is_dl = false
		return
	$Timer.start(1); yield($Timer, "timeout")
	for n in scores.size():
		scores[n] += 1
	print(current_points(), is_dl, downloads.size())
	score_manager()

func ad_spawner():
	pass

func spawn_window(app: String) -> void:
	var a = PD.prefabs.get(app).instance()
	add_window(a)
	pass

func spawn_ad() -> void:
	var a = PD.window_ads.get(rng.randi_range(0, PD.window_ads.size()-1)).instance()
	add_window(a)

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
			node.connect("dl_state", self, "download_manager")
			browsers.append(node)
		
		if node is Ad:
			ad_window_amount(false)
		$ComputerScreen/Windows.add_child(node)
		node.monitor_info[0] = $ComputerScreen/Windows.rect_global_position
		node.monitor_info[1] = $ComputerScreen/Windows.rect_size
		
		if node is Browser:
			node.win_pos = Vector2(1,2) * (win_amount-1)
		
		node.connect("move_to_top", self, "set_top_window")
		node.connect("close_window", self, "close_window")
		node._open_window()
		
	pass

func set_top_window(node : Node) -> void:
	$ComputerScreen/Windows.move_child(node, $ComputerScreen/Windows.get_child_count() - 1)
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
	if node is Browser:
		var b = browsers.find(node)
		if b > -1:
			browsers.remove(b)
		window_amount_manager(true)
	if node is Ad:
		window_amount_manager(true)
		ad_window_amount(true)
	
	pass

func _process(delta):
	if Input.is_action_just_pressed("mouse_button") or Input.is_action_just_released("mouse_button"):
		var a = PD.prefabs.get("mouse").instance()
		$ComputerScreen.add_child(a)
	
	if start_time:
		player_time += delta
		$ComputerScreen/TaskBar/Player_Timer.text = current_time()
	
	pass

func current_time() -> String:
	var seconds : float = fmod(player_time, 60.00)
	var minutes : int = int(player_time / 60.00) % 60
	var mmss_string : String = "%02d:%05.2f" % [minutes, seconds]
	return mmss_string


func current_points() -> int:
	var p = 0
	for n in scores.size():
		p += scores[n]
	p += total_score
	$ComputerScreen/TaskBar/Score.text = "Completed Downloads: {0} , {1} {2}".format({0 : c_dls, 1 : p, 2 : "Streak x " + str(cur_multi) if cur_multi > 0 else ""})
	return p
	pass

# Adds ads depending on the amount of downloads going on
func manage_ads():
	var i = 0
	
	if downloads.size() < 1:
		print("no downloads")
		is_dl = false
		return
	
	for n in 2 * downloads.size():
		i = rng.randi_range(0,2)
		match i:
			# is a tab
			0:
				i = rng.randi_range(0,downloads.size()-1)
				downloads[i].window.spawn_tab_ad(rng.randi_range(0,PD.tab_ads.size()-1))
				pass
			_:
				spawn_ad()
				pass
#			_:
#				spawn_window("adBasic")
#				pass
				
	$AdTimer.start(rng.randf_range(3, ad_freq / downloads.size() + 1)); yield($AdTimer, "timeout")
	manage_ads()
	
	pass
# Used to affect how the screen of the computer looks depending oon the amount of processes are running
func computer_state():
	
	meter = clamp(meter + (get_influence() / 40),0.0,1.0)
	print(meter)
	
	# StaticNoiseIntensity = 0.03 (max 0.2), Aberration = 0.005 (max 0.02), Color Modulate (1.0,0.86,0.67)
	screen.material.set("shader_param/static_noise_intensity", lerp(0.03, 0.2, meter))
	screen.material.set("shader_param/aberration", lerp(0.005, 0.01, meter))
	screen.self_modulate = Color(1,1,1).linear_interpolate(Color(1.0, 0.86, 0.67), meter)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("PC_Fan"), lerp(-5, 5, meter))
	$ComputerScreen/TaskBar/ProgressBar.value = meter
	
	if c_dls >= 5:
		$PCStartup._winscreen(current_points(), total_score, player_time, high_multi, c_dls)
		$StateTimer.start(0.5); yield($StateTimer, "timeout")
		_shutdown()
	
	if meter >= 0.99:
		$PCStartup._bluescreen(current_points(), total_score, player_time, high_multi, c_dls)
		_shutdown()
		$StateTimer.start(0.3); yield($StateTimer, "timeout")
		return
	
	$StateTimer.start(1); yield($StateTimer, "timeout")
	computer_state()
	pass

func get_influence() -> float:
	var i : float = -1
	
	for n in ad_threshold.size():
		if ad_amount > ad_threshold[n]:
			i += 1
	print("influence: ", i," meter: ", meter)
	return i

func completed_downloads(c_d : bool):
	if c_d:
		c_dls += 1
		cur_multi += 1
		if cur_multi > high_multi:
			high_multi = cur_multi
		pass
	else:
		cur_multi = 0


func game_completed() -> void:
	pass


func shutdown_sequence() -> void:
	pass

func _shutdown() -> void :
	var c = $ComputerScreen/Windows.get_children()
	for n in c.size():
		c[n].queue_free()
	total_score = 0
	cur_multi = 0
	high_multi = 0
	c_dls = 0
	win_amount = 0
	browsers= []
	win_mini = 0
	ad_windows = 0
	ad_amount = 0
	start_time = false
	$ComputerScreen/TaskBar/Score.text = ""
	$ComputerScreen/TaskBar/Player_Timer.text = ""
	player_time = 0.00
	
	downloads = []
	scores = []
	is_dl = false
	pass

#func ad_handler():
#
#	pass
