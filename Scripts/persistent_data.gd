extends Node

# SSS, S, A, B, C, D, E, F
const time_grade = [75,90,100,120,150,180,190,200]
const multi_grade = [5,4,3,2,1]

const titles = [
	"Schrec",
	"Captain Lepton",
	"Wood Crank Liquid",
	"McJohnalds/McDuncans Adventure ™",
	"BurgerQueen The Game",
	"Dinosaur Tale",
	"The Beginning of Us",
	"The Egyptian Corpse",
	"Mending Good",
	"Sol's Your Man",
	]

const ad_titles = [
	"This is an ad This is an ad This is an ad This is an ad This is an ad This is an ad This is an ad This is an ad This is an ad This is an ad\nThis is an ad This is an ad\nThis is an ad This is an ad\nThis is an ad This is an ad\nThis is an ad This is an ad\nThis is an ad This is an ad\nThis is an ad This is an ad\nThis is an ad This is an ad\nThis is an ad This is an ad",
	"[font=res://UI/Font/AweMonoGold.tres][color=lime]MONEY MONEY MONEY ;P MONEY MONEY MONEY MONEY[/font]",
	"[font=res://UI/Font/AweMonoGold.tres][wrb]GET YOUR FREE CAR WASH TODAY FOR ABSOLUTELY FREEEEEE!!!!![/wrb][/font]",
	"[font=res://UI/Font/softballgold.tres][eq]YOU!!! HAVE!!! BEEEN!!!\nHACKED!!![/eq][/font]\n\nDownload our latest internet protection service for 10% off B-)",
	"[font=res://UI/Font/softballgold.tres] Psshhhh....\n\nWant some corn...\nOff the cob?[/font]"
]


onready var textures : Array = [
	load("res://AdPictures/Ad Visuals/bananas.png"),
	load("res://AdPictures/Ad Visuals/krabs.png"),
	load("res://AdPictures/Ad Visuals/sans.png"),
	load("res://AdPictures/Ad Visuals/skonic.png"),
	load("res://AdPictures/Ad Visuals/someguy.png"),
	]




onready var paths : Array = ["res://Scenes/MainGame.tscn"]
onready var prefabs : Dictionary = {
	"webBrowser" : preload("res://Prefab/Apps/WebWindow.tscn"),
	"paint" : preload("res://Prefab/Apps/PaintWindow.tscn"),
	"notes" : preload("res://Prefab/Apps/notepad.tscn"),
	"note" : preload("res://Prefab/Apps/Note.tscn"),
	"mouse" : preload("res://Prefab/MouseClick.tscn"),
	"credits" : preload("res://Prefab/Apps/Credits.tscn"),
	}

onready var window_ads : Dictionary = {
	0 : preload("res://Prefab/Ads/Ad.tscn"),
	1 : preload("res://Prefab/Ads/AdBouncing.tscn"),
	}

onready var tabs : Dictionary = {
	"gergle" : preload("res://Prefab/Tabs/Gergle.tscn"),
	"pirate" : preload("res://Prefab/Tabs/PirateCreek.tscn"),
	"hecker" : preload("res://Prefab/Tabs/HeckerForum.tscn"),
	"fly" : preload("res://Prefab/Tabs/fly.tscn"),
	}
onready var tab_ads : Dictionary = {
	0 : preload("res://Prefab/Tabs/Ads/AdSan.tscn"),
	1 : preload("res://Prefab/Tabs/Ads/AdKrab.tscn"),
	2 : preload("res://Prefab/Tabs/Ads/AdBK.tscn"),
	
	}

onready var mon_bor : Array = [24,16]
onready var mon_size : Array = [316,218]



#onready var sound : Array = [load("res://SFX/ButtonSound.wav"), load("res://SFX/Backsound.wav"), load("res://SFX/BlockPlace.wav")]

static func monitorPos() -> Vector2:
	return Vector2(24 + 316, 16 + 218)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
