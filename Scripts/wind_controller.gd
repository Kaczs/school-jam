extends Node

func _process(delta):
	if Input.is_key_pressed(KEY_ENTER):
		print("Pressing Key")
		global_wind()


func global_wind():
	print("Winnnnnd")
	var targets = get_tree().get_nodes_in_group("affected by wind")
	for target in targets:
		target.parent_body.apply_force(Vector2(1000, 1000))

# Find Direction

# Apply force in that direction
