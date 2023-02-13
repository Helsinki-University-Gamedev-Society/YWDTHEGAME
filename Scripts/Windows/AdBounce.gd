class_name AdBounce
extends Ad

var min_max_velocity = [32, 64.0]
var velocity = Vector2.ZERO

func _init():
	win_sizes = [24,88]


func window_property() -> void:
	set_velocity()
	bg.texture = PD.textures[rng.randi_range(0, PD.textures.size() -1)]
	$Icon/WindowContent.bbcode_text = PD.ad_titles[rng.randi_range(0, PD.ad_titles.size() - 1)]
	pass

func window_content() -> void:
	window.rect_position = Vector2(2,dragbar.rect_size.y + 2)
	window.rect_size = $Icon.rect_size - Vector2(2,dragbar.rect_size.y + 2)
	$Icon/ScrollBG.rect_position = window.rect_position
	$Icon/ScrollBG.rect_size = window.rect_size
	pass


#sets random velocity and direction
func set_velocity():
	var angle = rng.randf_range(0, 360)
	var speed = rng.randf_range(min_max_velocity[0], min_max_velocity[1])
	var x_velocity = cos(angle)*speed
	var y_velocity = sin(angle)*speed
	velocity = Vector2(x_velocity, y_velocity)
#	velocity = Vector2(0,100)

#Bounces ad off of monitor edges
func bounce():
	if rect_position.x <= 0 or rect_position.x >= monitor_info[1].x - $Icon.rect_size.x:
		velocity = velocity.bounce(Vector2(1, 0))

	if rect_position.y <= 0 or rect_position.y >= monitor_info[1].y - $Icon.rect_size.y:
		velocity = velocity.bounce(Vector2(0, 1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state != winState.FULLSCREEN and state != winState.MINIMIZE:
		bounce()
		rect_position += velocity*delta
		pass
