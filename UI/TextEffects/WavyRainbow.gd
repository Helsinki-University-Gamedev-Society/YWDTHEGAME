tool
extends RichTextEffect
class_name RichTextWavyRainbow

#bbcode [WRB freq=#]text[/WRB]
var bbcode = "wrb"

func _process_custom_fx(char_fx):
	var freq = char_fx.env.get("freq", 3)*char_fx.elapsed_time*2*PI + char_fx.absolute_index
	char_fx.offset += Vector2(0, sin(freq))
	char_fx.color = Color.red
	char_fx.color.h = lerp(char_fx.color.h, freq, 0.05)
	
	return true
