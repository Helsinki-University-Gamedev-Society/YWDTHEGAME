extends Control

signal shutdown

onready var power_button = $"../TextureButton"

var power : bool = false

func _ready():
	$AnimationPlayer.play("RESET")

func _pc_start() -> void:
	if not power:
		power = true
		$AnimationPlayer.play("PC_startup")
		$".."._start_computer()
	else:
		#Spawn Shutdown Popup
		$Timer.start(2); yield($Timer, "timeout")
		if power_button.pressed:
			emit_signal("shutdown")
			power = false
			$AnimationPlayer.play("RESET")
			$FinalScore.bbcode_text = ""
	pass

func time_format(t:float) -> String:
	var seconds : float = fmod(t, 60.00)
	var minutes : int = int(t / 60.00) % 60
	var mmss_string : String = "%02d:%05.2f" % [minutes, seconds]
	return mmss_string

func total_score(p,t,m,dl) -> Array:
	var final = ["",0,0.0]
	if dl == 0:
		dl = 1
	
	
	final[2] = t / dl
	
	var s_t : float = 0
	var s_m : float = 0
	for n in PD.time_grade.size():
		if final[2] > PD.time_grade[n]:
			s_t += 1
	for n in PD.multi_grade.size():
		if m < PD.multi_grade[n]:
			s_m += 1
	var f_grade : int = (7 - round(s_t + s_m / 2))
	
	print("s_t: ",s_t, " s_m: ",s_m, " Grade: ", f_grade)
	match f_grade:
		7: 
			final[0] = "[font=res://UI/Font/AweMonoGold.tres][wrb]SSS[/wrb][/font]"
		6:
			final[0] = "[font=res://UI/Font/AweMonoGold.tres][color=yellow]S[/color][/font]"
		5:
			final[0] = "[font=res://UI/Font/AweMonoGold.tres][color=red]A[/color][/font]"
		4:
			final[0] = "[font=res://UI/Font/AweMonoGold.tres][color=green]B[/color][/font]"
		3:
			final[0] = "[font=res://UI/Font/AweMonoGold.tres][color=aqua]C[/color][/font]"
		2:
			final[0] = "[font=res://UI/Font/AweMonoGold.tres][color=silver]D[/color][/font]"
		1:
			final[0] = "[font=res://UI/Font/AweMonoGold.tres][color=purple]D[/color][/font]"
		_:
			final[0] = "[font=res://UI/Font/AweMonoGold.tres][eq freq=1][color=red]F[/color][/eq][/font]"
		
	final[1] = p * f_grade
	return final

func _bluescreen(p : int, r_p : int, t : float, m : int, dl : int) -> void:
	var f = total_score(r_p,t,m,dl)
	$AnimationPlayer.play("Bluescreen"); yield($AnimationPlayer,"animation_finished")
	var txt : String = "-----------------------------\nYour evaluation of Efficency:\n-----------------------------\n\nPsuedo-Points: {0}\n\nReal Points: {1}\n\nTime: {2} / Average Time: {5}\n\nMultiplier: {3}\n\nDownloads: {4}\n\n Predicted Grade: {6}".format({0:p, 1:r_p, 2:time_format(t), 3:m, 4:dl,5: time_format(f[2]), 6:f[0]})
	$FinalScore.bbcode_text = txt
	pass

func _winscreen(p : int, r_p : int, t : float, m : int, dl : int) -> void:
	var f = total_score(r_p,t,m,dl)
	$AnimationPlayer.play("Winscreen"); yield($AnimationPlayer,"animation_finished")
	var txt : String = "-----------------------------\nYour evaluation of Efficency:\n-----------------------------\n\nPsuedo-Points: {0}\n\nReal Points: {1}\n\nTime: {2} / Average Time:{7}\n\nMultiplier: {3}\n\nDownloads: {4}\n\nTotal Score: {5}\n\nGrade: {6}".format({0:p, 1:r_p, 2:time_format(t), 3:m, 4:dl, 5:f[1], 6:f[0], 7:time_format(f[2])})
	$FinalScore.bbcode_text = txt
	pass

