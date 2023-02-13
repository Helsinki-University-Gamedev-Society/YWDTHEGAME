class_name Gergle
extends WindowTabs



func _pirate_tab():
	tab_parent.spawn_tab("pirate")
	pass

func _yootune_tab():
	tab_parent.spawn_tab("hecker")
#	var p = get_parent()
#	if p is TabContainer:
#		p.spawn_tab("pirate")
	pass

func _mitgnome_tab():
	tab_parent.spawn_tab("fly")
#	var p = get_parent()
#	if p is TabContainer:
#		p.spawn_tab("pirate")
	pass
