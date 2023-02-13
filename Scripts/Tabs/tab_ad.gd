class_name TabAd
extends WindowTabs



func _ready():
	ad_loop()
	pass


func ad_loop():
	$Timer.start(0.5); yield($Timer, "timeout")
	$WindowContent/bg.flip_h = true
	$Timer.start(0.5); yield($Timer, "timeout")
	$WindowContent/bg.flip_v = true
	$Timer.start(0.5); yield($Timer, "timeout")
	$WindowContent/bg.flip_h = false
	$Timer.start(0.5); yield($Timer, "timeout")
	$WindowContent/bg.flip_v = false
	ad_loop()
