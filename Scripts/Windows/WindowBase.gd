class_name ProgramWindow
extends Control

signal move_to_top(Node)
signal close_window(Node)

onready var opt_cont = $Icon/OptionContainer
onready var mini_button = $Icon/OptionContainer/MiniButton
onready var fs_button = $Icon/OptionContainer/FullScreenButton
onready var close_button = $Icon/OptionContainer/CloseButton
onready var win_label = $Icon/Label
onready var dragbar = $DragBar
onready var window = $Icon/WindowContent

export var win_name : String = "Unnamed"

# To handle the drag bar nicely when it changes sizes
var prev_leng : int = 0
var adj_pos : int = 0

# [0] = Monitor Position, [1] = Monitor Size
var monitor_info : Array = [Vector2.ZERO,Vector2.ZERO]

# Used to set the window position
var win_pos := Vector2.ZERO
# Sets the size of the window
var win_size := Vector2.ZERO

var drag_pos := Vector2.ZERO


enum winState {NORMAL, FULLSCREEN, MINIMIZE}
var state : int = 0
# [0] = Fullscreen, [1] = Minimize
#var state : Array = [false, false]

# Called when the node enters the scene tree for the first time.
func _open_window():
	set_connections()
	window_setup()
	pass # Replace with function body.

func set_connections() -> void:
	$DragBar.connect("gui_input", self, "_on_DragBar_gui_input")
	#$Icon.connect("gui_input",self,"_on_Window_gui_input")
	mini_button.connect("pressed", self, "_on_Mini_pressed")
	fs_button.connect("pressed", self, "_on_FullScreen_pressed")
	close_button.connect("pressed", self, "_on_Close_pressed")
	
	pass


func window_setup() -> void:
	window_parameters()
	set_dragbar(int(win_size.x))
	window_content()
	pass

func window_parameters() -> void:
	win_size = Vector2(288, 192)
	$Icon.rect_size = win_size
	win_pos = Vector2(16,16)
	rect_position = win_pos
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_dragbar(size: int) -> void:
	dragbar.rect_size.x = size - opt_cont.rect_size.x
	win_label.rect_size.x = dragbar.rect_size.x - 6
	pass

func window_content() -> void:
	window.rect_position = Vector2(2,dragbar.rect_size.y + 2)
	window.rect_size = $Icon.rect_size - Vector2(2,dragbar.rect_size.y + 2)
	pass

# Used to drag the window around
func _on_DragBar_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			# Dragging
			drag_pos = get_global_mouse_position() - rect_global_position
			emit_signal("move_to_top", self)
			pass
		else:
			drag_pos = Vector2.ZERO
			adj_pos = 0
	if event is InputEventMouseMotion and drag_pos != Vector2.ZERO:
		if state == winState.FULLSCREEN:
			#win_pos = get_global_mouse_position()
			prev_leng = dragbar.rect_size.x
			_on_FullScreen_pressed()
			adj_pos = drag_pos.x * (dragbar.rect_size.x/prev_leng)
			print("called")
		if adj_pos == 0:
			adj_pos = drag_pos.x
		# By using the modulo we avoid the mouse grabbing a window it's not grabbing
		win_pos = get_global_mouse_position() - Vector2(adj_pos,drag_pos.y)
		# This prevents the window from letting the window get out of view
		rect_global_position = Vector2 (clamp(win_pos.x, monitor_info[0].x, monitor_info[0].x + monitor_info[1].x - 6), clamp(win_pos.y, monitor_info[0].y, monitor_info[0].y + monitor_info[1].y - 6))
		pass
	pass # Replace with function body.

func _on_FullScreen_pressed() -> void:
	emit_signal("move_to_top", self)
	if state == winState.FULLSCREEN:
		state = winState.NORMAL
		rect_global_position = win_pos
		$Icon.rect_size = win_size
		window_content()
		set_dragbar(int(win_size.x))
		pass
	else:
		state = winState.FULLSCREEN
		win_pos = rect_global_position
		rect_position = Vector2(0,0)
		$Icon.rect_size = monitor_info[1]
		window_content()
		set_dragbar(int(monitor_info[1].x))
		pass
	pass

func _on_Mini_pressed() -> void:
	emit_signal("move_to_top", self)
	if state == winState.MINIMIZE:
		state = winState.NORMAL
		rect_global_position = win_pos
		$Icon.rect_size = win_size
		window_content()
		set_dragbar(int(win_size.x))
	else:
		state = winState.MINIMIZE
		win_pos = rect_global_position
		rect_position = Vector2(16,monitor_info[1].y-8)
		$Icon.rect_size = Vector2(32,48)
		window_content()
		set_dragbar(int(32))
	pass

func _on_Close_pressed() -> void:
	print("close")
	emit_signal("close_window", self)
	# There can be a timer for how long it takes before a window closes
	queue_free()
	pass
