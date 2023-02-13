class_name Ad
extends ProgramWindow

#onready var opt_cont = $Icon/OptionContainer
#onready var dragbar = $DragBar
#onready var window = $Icon/WindowContent

# Used to set the range of where the window is placed
#onready var win_border : Array = [0,200,0,160]
# Range of the size for the window
#onready var win_sizes : Array = [16,128]

# Used to set the window position
#var win_pos := Vector2.ZERO
# Sets the size of the window
#var win_size := Vector2.ZERO
#
#var drag_pos := Vector2.ZERO

onready var bg = $Icon/ScrollBG

var rng = RandomNumberGenerator.new()

# Range of the size for the window
var win_sizes : Array = [18,128]

# Gets called by it's parent ready() function
# This func
func window_setup() -> void:
	rng.randomize()
	set_random_size()
	set_random_pos()
	window_property()
	set_dragbar(int(win_size.x))
	window_content()
	print(rect_position)

# This is used to set any specific properties of the ad window
# and is called by the ready() function
func window_property() -> void:
	bg.texture = PD.textures[rng.randi_range(0, PD.textures.size() -1)]
	$Icon/WindowContent.bbcode_text = PD.ad_titles[rng.randi_range(0, PD.ad_titles.size() - 1)]
	pass

func window_content() -> void:
	window.rect_position = Vector2(2,dragbar.rect_size.y + 2)
	window.rect_size = $Icon.rect_size - Vector2(2,dragbar.rect_size.y + 2)
	bg.rect_position = window.rect_position
	bg.rect_size = window.rect_size
	bg.material.set("shader_param/direction",Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1)))
	bg.material.set("shader_param/speed",rng.randf_range(0.2,1.0))
	
	pass


func set_random_size() -> void:
	win_size = Vector2(rng.randi_range(win_sizes[0],win_sizes[1]),rng.randi_range(win_sizes[0],win_sizes[1]))
	$Icon.rect_size = win_size
	pass

func set_random_pos() -> void:
	# Places the window within the screens boundary
	win_pos = Vector2(rng.randi_range(monitor_info[0].x, monitor_info[1].x - win_size.x), rng.randi_range(monitor_info[0].y, monitor_info[1].y -win_size.y)) #- Vector2(6,6)
	rect_global_position = win_pos
	pass
