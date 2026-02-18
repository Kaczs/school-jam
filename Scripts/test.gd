extends Node2D

func _ready() -> void:
	when_complete()


func when_complete():
	LevelManager.level_complete(self)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("UI_Back"):
		get_tree().change_scene_to_file("res://MainMenu/main.tscn")
