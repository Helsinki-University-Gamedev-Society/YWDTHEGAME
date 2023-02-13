tool
extends RichTextEffect
class_name RichTextEarthQuake

#bbcode [eq freq=#]text[/eq]
var bbcode = "eq"

func _process_custom_fx(char_fx):
	var freq = char_fx.env.get("freq", 3)*char_fx.elapsed_time*2*PI
	var amp = char_fx.env.get("amp", 3)
	char_fx.offset += Vector2(-0.6*sin(freq - char_fx.absolute_index), amp*sin(3*freq + 2.5*char_fx.absolute_index) )
	
	return true
