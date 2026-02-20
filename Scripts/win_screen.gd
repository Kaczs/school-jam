extends Control

@export var next_level:PackedScene

func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_packed(next_level)


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main.tscn")
