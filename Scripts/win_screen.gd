extends Control

@export var path_to_next_level:String 

func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file(path_to_next_level)


func _on_restart_pressed() -> void:
	var curent_scene:String = get_tree().root.name.to_lower()
	get_tree().change_scene_to_packed(LevelManager.level_unlocks[curent_scene])


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main.tscn")
