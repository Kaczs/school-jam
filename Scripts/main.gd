extends Control

@onready var level_select = $LevelSelect
@onready var settings = $CenterContainer/HBoxContainer/Settings2
@onready var main_menu = $CenterContainer

func _on_play_pressed() -> void:
	main_menu.hide()
	level_select.show()
	settings.hide()


func _on_settings_pressed() -> void:
	settings.visible = not settings.visible

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("UI_Back"):
		if settings.visible:
			settings.hide()
		elif not main_menu.visible:
			main_menu.show()
			level_select.hide()
