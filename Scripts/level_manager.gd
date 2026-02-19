extends Node

var unlocked_levels:Array = [preload("res://Scenes/Levels/test.tscn"), preload("res://Scenes/Levels/level1.tscn")]

var level_unlocks:Dictionary = {
	"test":preload("res://Scenes/Levels/tower_testing.tscn")
}




func level_complete(level):
	var level_name:String = level.name.to_lower()
	unlocked_levels.append(level_unlocks[level_name])
