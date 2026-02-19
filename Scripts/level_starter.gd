extends Node2D
## This manages winning and starting the spawner
@export var tutorial := false

func _ready():
	EventBus.connect("all_enemies_dead", win)
	EventBus.connect("player_lose", lose)
	var spawner:EnemySpawner = get_node_or_null("EnemySpawner")
	if tutorial == false:
		spawner.begin_spawns()

func win():
	LevelManager.level_complete(self)
	var scene = load("res://MainMenu/main.tscn")
	get_tree().change_scene_to_packed(scene)

func lose():
	var scene = load("res://MainMenu/main.tscn")
	get_tree().change_scene_to_packed(scene)
