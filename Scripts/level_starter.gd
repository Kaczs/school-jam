extends Node2D
## This manages winning and starting the spawner

func _ready():
	EventBus.connect("all_enemies_dead", win)
	var spawner:EnemySpawner = get_node_or_null("EnemySpawner")
	spawner.begin_spawns()

func win():
	LevelManager.level_complete(self)
	ResourceLoader.load("res://Scenes/level_menu.tscn")
