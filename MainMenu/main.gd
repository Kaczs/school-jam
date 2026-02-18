extends Control

@onready var settings = $CenterContainer/HBoxContainer/Settings2

func _on_play_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	settings.visible = not settings.visible

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("UI_Back"):
		settings.visible = false
