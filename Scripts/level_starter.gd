extends Node2D
## This just exists to initate the spawner
## or any level starting stuff I can think of
## (I dont have this on level 1, since tutorial does this)

func _ready():
	var spawner:EnemySpawner = get_node_or_null("EnemySpawner")
	spawner.begin_spawns()