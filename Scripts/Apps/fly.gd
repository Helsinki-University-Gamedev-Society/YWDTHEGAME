extends Node2D

onready var audio = $audio
onready var bgm = load("res://Sprites/pumpkin_shenanigans/LOOP_GameBackground.ogg")
onready var ultimate_start = load("res://Sprites/pumpkin_shenanigans/UltimateAbility.ogg")
onready var ultimate_loop = load("res://Sprites/pumpkin_shenanigans/buzzlord.ogg")
onready var progress = $"../ProgressBar"

var dragging = false
var speed = 0
var song = ""

func _ready():
	progress.max_value = 420
	# Connect to the Area2D input signal so we know when the user clicks on it
	$Control/ClickArea.connect("button_down", self, "_on_down")
	$Control/ClickArea.connect("button_up", self, "_on_up")
	set_process_input(true)
	$audio.connect("finished", self, "_on_finished")


func _on_down():
		dragging = true

func _on_up():
		dragging = false


func _input(event):
	if dragging:
		if event is InputEventMouseMotion:
			var motion = event.relative
			var new_pos = get_global_mouse_position()
			var prev_pos = new_pos - motion
			var center = position
			# Calculate the angular motion of the crank based on the arc made with the mouse
			var angle = (prev_pos - center).angle_to(new_pos - center)
			rotate(angle*speed)
			speed += abs(angle)
			#print(speed)
			progress.value = speed
			if abs(speed) >= 420 and song != "ultimate":
				song = "ultimate"
				audio.set_stream(ultimate_start)
				audio.play()
				
		elif event is InputEventMouseButton and event.pressed == false:
			# Stop dragging when the user releases the mouse button
			dragging = false
			if song != "bgm":
				audio.set_stream(bgm)
				audio.play()
				song = "bgm"
				

func _on_finished():
	audio.set_stream(ultimate_loop)
	audio.play()
