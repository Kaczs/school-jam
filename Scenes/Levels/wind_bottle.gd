extends AnimatedSprite2D

func _ready():
	# Grab the wind change signal from the event bus
	play("2")
	EventBus.connect("wind_changed", update_stage)

## Update the animation based on the amount of wind
func update_stage(wind_count:int):
	play(str(wind_count))