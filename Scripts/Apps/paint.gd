extends Control

signal selected_color

onready var _lines = $lines
var _current_line = Line2D
var _pressed = false
var width = 5
var selected_color = Color.cyan

onready var colors = $colors
onready var x_range = Vector2(rect_position.x + width, rect_size.x - width)
onready var y_range = Vector2(rect_position.y - width, rect_size.y - width)

#drawing and shit
func _on_lines_gui_input(event) -> void:
	if event is InputEventMouseButton and in_bounds(event.position):
		_pressed = event.pressed
		if _pressed:
			_current_line = Line2D.new()
			_current_line.default_color = selected_color
			_current_line.width = width
			_lines.add_child(_current_line)
	if event is InputEventMouseMotion and _pressed and in_bounds(event.position):
		_current_line.add_point(event.position)
		
#checks if a click falls within the bounds of the drawing area
func in_bounds(pos: Vector2):
	if pos.x <= x_range.y and pos.x >= x_range.x and pos.y <= y_range.y and pos.y >= y_range.x:
		return true
	return false

#color selection
func _on_color_pressed(color):
	selected_color = color
