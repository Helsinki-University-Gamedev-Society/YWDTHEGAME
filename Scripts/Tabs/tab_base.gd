class_name WindowTabs
extends Tabs

signal tab_info (Node)

var tab_parent : Node

var is_ad : bool = false
onready var close_button = $CloseButton


func _ready():
	close_button.connect("pressed", self, "_close_tab")
	pass

func set_tab_size(size: Vector2) -> void:
	rect_size = size
	$WindowContent.rect_size = size
	$WindowContent.get_child(0).rect_min_size.x = size.x
	pass


func _close_tab() -> void:
	emit_signal("tab_info",self)
	pass
