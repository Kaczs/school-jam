class_name EnemySpawner extends Node2D
@export var to_spawn:Array[SpawnEntry]

@onready var spawn_timer:Timer = $SpawnTimer
signal spawns_complete

## Iterate through all the entries in the to_spawn list
## for each entry spawn 1 then wait for the timer to complete
## do this until you've done one for every count, then
## move onto the next entry.
func begin_spawns():
	for spawn in to_spawn:
		for count in spawn.count: 
			var new_enemy = spawn.scene.instantiate()
			add_child(new_enemy)
			spawn_timer.wait_time = spawn.spawn_rate
			spawn_timer.start()
			await spawn_timer.timeout
	spawns_complete.emit()
