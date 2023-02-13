class_name PirateCreek
extends WindowTabs


# These signals must only be sent once, to indicate the start, the end, and an interruption
signal download_state

onready var prog_bar = $WindowContent/PirateCreek/ProgressBar
onready var down_note = $WindowContent/PirateCreek/DownloadNote
onready var line_edit = $WindowContent/PirateCreek/LineEdit
onready var search = $WindowContent/PirateCreek/SearchButton

var rng := RandomNumberGenerator.new()
var time_max : float
var time : float = 0.0
var time_range : Array = [80,160]

func _ready():
	rng.randomize()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _random_search() -> void:
	line_edit.text = PD.titles[rng.randi_range(0,PD.titles.size() - 1)]
	_on_search_pressed()
	pass

func _on_search_pressed():
	if line_edit.text.length() > 4:
		_on_text_entered(line_edit.text)
	else:
		down_note.text = "There must be at least 5 characters"
	pass # Replace with function body.

func _on_ad_pressed():
	tab_parent.spawn_tab_ad(rng.randi_range(0,PD.tab_ads.size()-1))
	pass # Replace with function body.

func _on_text_entered(new_text):
	search.disabled = true
	$WindowContent/PirateCreek/MovieButton.disabled = true
	$WindowContent/PirateCreek/GameButton.disabled = true
	down_note.text = "Downloading... '%s'"% new_text
	line_edit.editable = false
	emit_signal("download_state", 0)
	prog_bar.value = 0.0
	prog_bar.visible = true
	
	time = rng.randf_range(time_range[0],time_range[1])
	for n in 100:
		$Timer.start(time / 100);yield($Timer,"timeout")
		prog_bar.value += 1
		#print(prog_bar.value)
		
	emit_signal("download_state", 1)
	down_note.text = "Successfully downloaded '%s'"% new_text
	$AudioStreamPlayer.play()
	prog_bar.visible = false
	line_edit.editable = true
	search.disabled = false
	$WindowContent/PirateCreek/MovieButton.disabled = false
	$WindowContent/PirateCreek/GameButton.disabled = false
	pass # Replace with function body.

func _close_tab() -> void:
	emit_signal("download_state",2)
	emit_signal("tab_info",self)
	pass
