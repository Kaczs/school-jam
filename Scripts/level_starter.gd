class_name LevelStarter extends Node2D
## This manages winning and starting the spawner
@export var tutorial := false
@export var spawners:Array[EnemySpawner]

func _ready():
	EventBus.connect("all_enemies_dead", win)
	EventBus.connect("player_lose", lose)
	SoundManager.play_global(SoundFiles.backround_music, self ,"Music" ,-10 ,true)
	if tutorial == false:
		for spawner in spawners:
			spawner.begin_spawns()
		

func win(spawner:EnemySpawner):
	spawners.erase(spawner)
	if spawners.is_empty() and not $UI/LossScreen.visible:
		LevelManager.level_complete(self)
		$UI/WinScreen.show()

func lose():
	$UI/LossScreen.show()
