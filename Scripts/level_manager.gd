extends Node

var unlocked_levels:Array = [preload("res://Scenes/Levels/level1.tscn")]

var level_unlocks:Dictionary = {
	"level1":preload("res://Scenes/Levels/level2.tscn"),
	"level2":preload("res://Scenes/Levels/level3.tscn"),
	"level3":preload("res://Scenes/Levels/level4.tscn"),
	"level4":preload("res://Scenes/Levels/level5.tscn"),
	"level5":preload("res://Scenes/Levels/level6.tscn"),
	"level6":preload("res://Scenes/Levels/level7.tscn"),
	"level7":preload("res://Scenes/Levels/level8.tscn")
}




func level_complete(level):
	var level_name:String = level.name.to_lower()
	if unlocked_levels.has(level_unlocks[level_name]):
		return
	unlocked_levels.append(level_unlocks[level_name])
