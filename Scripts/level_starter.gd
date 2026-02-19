extends Node2D
## This manages winning and starting the spawner
@export var tutorial := false
@export var spawners:Array[EnemySpawner]

func _ready():
	EventBus.connect("all_enemies_dead", win)
	EventBus.connect("player_lose", lose)
	if tutorial == false:
		for spawner in spawners:
			spawner.begin_spawns()
		

func win(spawner:EnemySpawner):
	spawners.erase(spawner)
	if spawners.is_empty():
		LevelManager.level_complete(self)
		var scene = load("res://MainMenu/main.tscn")
		get_tree().change_scene_to_packed(scene)

func lose():
	var scene = load("res://MainMenu/main.tscn")
	get_tree().change_scene_to_packed(scene)
