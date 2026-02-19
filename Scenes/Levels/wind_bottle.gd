extends AnimatedSprite2D

func _ready():
	play("2")
	EventBus.connect("wind_changed", update_stage)

func update_stage(wind_count:int):
	print("Wind changed, updating bottle")
	play(str(wind_count))