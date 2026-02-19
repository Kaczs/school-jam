extends HBoxContainer

@onready var local_icon:TextureRect = $LocalWindIcon
@onready var global_icon:TextureRect = $GlobalWindIcon

func _ready():
	EventBus.connect("wind_mode", adjust_icons)

func adjust_icons(wind_option:String):
	print("Adjusting icons")
	if wind_option == "local":
		print("made local")
		local_icon.modulate.a = 1.0
		global_icon.modulate.a = 0.3
	elif wind_option == "global":
		print("made global")
		global_icon.modulate.a = 1.0
		local_icon.modulate.a = 0.3