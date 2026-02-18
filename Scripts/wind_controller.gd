extends Node

@export var wind_force = 1000
var drag_direction = Vector2(0, 0)
var accumulated_drag = Vector2.ZERO
@export var local_size:float = 600
var local_wind_mode = true

func _process(_delta):
	if Input.is_action_just_pressed("local_wind"):
		local_wind_mode = true
	if Input.is_action_just_pressed("global_wind"):
		local_wind_mode = false
	

# Getting the mouse drags to know what direction to send wind.
func _input(event: InputEvent) -> void:
	# If we press wind button, start tracking the motion.
	if Input.is_action_pressed("wind"):
		if event is InputEventMouseMotion:
			accumulated_drag += event.relative
	# Once we release the button act on that motion
	if Input.is_action_just_released("wind"):
		drag_direction = accumulated_drag.normalized()
		if local_wind_mode == false:
			global_wind(drag_direction)
		# if in local wind mode
		else:
			local_wind(drag_direction)
		accumulated_drag = Vector2.ZERO

## Use wind on everything in the group
func global_wind(direction:Vector2):
	var targets = get_tree().get_nodes_in_group("affected by wind")
	for target in targets:
		target.parent_body.apply_force(direction * wind_force)
		# Slow enemies temp. when hitting them with wind?

## Use wind on bodies near the mouse, as opposed to the entire group
## local wind is a bit stronger
func local_wind(direction:Vector2):
	var targets = get_tree().get_nodes_in_group("affected by wind")
	for target in targets:
		if target.global_position.distance_to(get_viewport().get_mouse_position()) <= local_size:
			#print("Target distance: ", target.global_position.distance_to(get_viewport().get_mouse_position()))
			target.parent_body.apply_force(direction * (wind_force*2))
