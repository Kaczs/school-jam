extends NavigationRegion2D

@onready var rebake_timer:Timer = $RebakeTimer

func _ready():
	EventBus.connect("moving_pathfinding_objects", rebake)
	# Bake when starting up, in case I forgot
	bake_navigation_polygon()

## Ideally the signal that calls this should only fire
## when we move things that require a rebake
func rebake():
	rebake_timer.start()

func _on_rebake_timer_timeout() -> void:
	print("rebaking the mesh")
	bake_navigation_polygon()
