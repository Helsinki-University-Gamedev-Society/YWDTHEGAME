extends Button

signal app_info(string)

export var app_name : String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _pressed():
	if $Timer.time_left > 0.1:
		$Timer.start(0.1)
		emit_signal("app_info", app_name)
		pass
	else:
		$Timer.start(0.3)
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
