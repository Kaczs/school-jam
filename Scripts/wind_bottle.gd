extends AnimatedSprite2D

var last_wind:int

func _ready():
	# Grab the wind change signal from the event bus
	play("2")
	EventBus.connect("wind_changed", update_stage)
	EventBus.connect("out_of_wind", no_wind)

## Update the animation based on the amount of wind
func update_stage(wind_count:int):
	play(str(wind_count))
	if last_wind < wind_count:
		# If we've gained wind make the bottle flash white
		self_modulate = Color(3, 3, 3, 1)
		var tween = create_tween()
		tween.tween_property(self, "self_modulate", Color(1, 1, 1, 1,), 0.8)
	last_wind = wind_count

func no_wind():
	self_modulate = Color(3, 3, 3, 1)
	var tween = create_tween()
	tween.tween_property(self, "self_modulate", Color.RED, 0.8)
