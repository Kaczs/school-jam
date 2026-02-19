class_name EnemySpawner extends Node2D
@export var to_spawn:Array[SpawnEntry]

@onready var spawn_timer:Timer = $SpawnTimer
signal spawns_complete

## Iterate through all the entries in the to_spawn list
## for each entry spawn 1 then wait for the timer to complete
## do this until you've done one for every count, then
## move onto the next entry.
func begin_spawns():
	spawn_timer.start()
	await spawn_timer.timeout
	for spawn in to_spawn:
		for count in spawn.count: 
			# Test if space is blocked if so move the spawn point up and to the left a bit
			# this is prevent the player from blocking the spawn with a crate.
			if check_for_blocked_spawns():
				position += Vector2(50, -50)
			var new_enemy = spawn.scene.instantiate()
			add_child(new_enemy)
			spawn_timer.wait_time = spawn.spawn_rate
			spawn_timer.start()
			await spawn_timer.timeout
	spawns_complete.emit()

func check_for_blocked_spawns():
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collide_with_bodies = true
	query.collide_with_areas = true
	var result = get_world_2d().direct_space_state.intersect_point(query)
	if result:
		return true
	else:
		return false

## This will track the last of the enemies and emit a signal when they're all dead
## signalling the level is complete.
func track_last_enemies():
	pass
