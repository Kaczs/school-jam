extends Node

@export var wind_force = 1000
var drag_direction = Vector2(0, 0)

func global_wind(direction:Vector2):
	print("Winnnnnd")
	var targets = get_tree().get_nodes_in_group("affected by wind")
	for target in targets:
		target.parent_body.apply_force(Vector2(direction.x * wind_force, direction.y * wind_force))

# Getting the mouse drags to know what direction to send wind.
func _input(event: InputEvent) -> void:
	# If we press wind button, start tracking the motion.
	if Input.is_action_pressed("wind"):
		if event is InputEventMouseMotion:
				drag_direction = event.relative.normalized()
	# Once we release the button act on that motion
	if Input.is_action_just_released("wind"):
		global_wind(drag_direction)
